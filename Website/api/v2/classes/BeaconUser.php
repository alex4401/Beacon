<?php
	
class BeaconUser implements JsonSerializable {
	const OmniFree = false;
	
	protected $user_id = '';
	protected $username = null;
	protected $email_id = null;
	protected $public_key = '';
	protected $private_key = null;
	protected $private_key_salt = null;
	protected $private_key_iterations = null;
	protected $signatures = array();
	protected $purchased_omni_version = 0;
	protected $expiration = '';
	protected $usercloud_key = null;
	protected $banned = false;
	protected $enabled = true;
	protected $parent_account_id = null;
	protected $require_password_change = false;
	protected $email_verified = false;
	
	private $has_child_accounts = null;
	private $child_accounts = null;
	
	public function __construct($source = null) {
		if ($source instanceof BeaconRecordSet) {
			$this->user_id = $source->Field('user_id');
			$this->username = $source->Field('username');
			$this->email_id = $source->Field('email_id');
			$this->public_key = $source->Field('public_key');
			$this->private_key = $source->Field('private_key');
			$this->private_key_salt = $source->Field('private_key_salt');
			$this->private_key_iterations = intval($source->Field('private_key_iterations'));
			$this->usercloud_key = $source->Field('usercloud_key');
			$this->banned = $source->Field('banned');
			$this->enabled = $source->Field('enabled');
			$this->parent_account_id = $source->Field('parent_account_id');
			$this->require_password_change = $source->Field('require_password_change');
			$this->email_verified = $source->Field('email_verified');
			
			if (self::OmniFree) {
				$this->purchased_omni_version = 1;
			} elseif ($this->enabled === true) {
				$database = BeaconCommon::Database();
				if (is_null($this->parent_account_id)) {
					$purchases = $database->Query('SELECT DISTINCT product_id FROM purchased_products WHERE purchaser_email = $1;', $this->email_id);
				} else {
					$purchases = $database->Query('SELECT DISTINCT product_id FROM purchased_products INNER JOIN users ON (purchased_products.purchaser_email = users.email_id) WHERE users.user_id = $1;', $this->parent_account_id);
				}
				while (!$purchases->EOF()) {
					$omni_version = 0;
					$product_id = $purchases->Field('product_id');
					switch ($product_id) {
					case '972f9fc5-ad64-4f9c-940d-47062e705cc5':
						$omni_version = 1;
						break;
					}
					$this->purchased_omni_version = max($this->purchased_omni_version, $omni_version);
					$purchases->MoveNext();
				}
			}
		} elseif (is_null($source)) {
			$this->user_id = BeaconCommon::GenerateUUID();
		}
	}
	
	public function UserID() {
		return $this->user_id;
	}
	
	public function CloudUserID() {
		// Since child accounts share the same cloud bucket as the parent, this returns the parent id for child accounts.
		if (is_null($this->parent_account_id)) {
			return $this->user_id;
		} else {
			return $this->parent_account_id;
		}
	}
	
	public function Email() {
		return $this->email_id;
	}
	
	public function Suffix() {
		return substr($this->user_id, 0, 8);
	}
	
	public function LoginKey() {
		return $this->username;
	}
	
	public function Username() {
		return $this->username;
	}
	
	public function SetUsername(string $username) {
		$this->username = trim($username);
	}
	
	public function PublicKey() {
		return $this->public_key;
	}
	
	public function SetPublicKey(string $public_key) {
		if (is_null($this->public_key) || $public_key !== $this->public_key) {
			$this->public_key = $public_key;
			$this->usercloud_key = null;
			$this->AssignUsercloudKey();
		}
	}
	
	public function PrivateKey() {
		return $this->private_key;
	}
	
	public function DecryptedPrivateKey(string $password) {
		$hash = BeaconEncryption::HashFromPassword($password, hex2bin($this->private_key_salt), $this->private_key_iterations);
		try {
			$decrypted = BeaconEncryption::SymmetricDecrypt($hash, hex2bin($this->private_key));
			if (is_null($decrypted)) {
				return false;
			}
			if (strtolower(substr($this->private_key, 0, 4)) === '8a01') {
				$encrypted = bin2hex(BeaconEncryption::SymmetricEncrypt($hash, $decrypted, false));
				$database = BeaconCommon::Database();
				$database->BeginTransaction();
				$database->Query('UPDATE users SET private_key = $2 WHERE user_id = $1;', $this->user_id, $encrypted);
				$database->Commit();
				$this->private_key = $encrypted;
				unset($encrypted);
			}
			return $decrypted;
		} catch (Exception $e) {
			return null;
		}
	}
	
	public function PrivateKeySalt() {
		return $this->private_key_salt;
	}
	
	public function PrivateKeyIterations() {
		return $this->private_key_iterations;
	}
	
	public function IsAnonymous() {
		return empty($this->email_id);
	}
	
	public function OmniVersion() {
		return $this->purchased_omni_version;
	}
	
	public function IsBanned() {
		return $this->banned;
	}
	
	public function IsEnabled() {
		return $this->enabled;
	}
	
	public function SetIsEnabled(bool $enabled) {
		$this->enabled = $enabled;
	}
	
	public function IsChildAccount() {
		return is_null($this->parent_account_id) === false;
	}
	
	public function HasChildAccounts() {
		if (is_null($this->has_child_accounts)) {
			$database = BeaconCommon::Database();
			$results = $database->Query('SELECT COUNT(user_id) AS user_count FROM users WHERE parent_account_id = $1;', $this->user_id);
			$this->has_child_accounts = intval($results->Field('user_count')) > 0;
		}
		return $this->has_child_accounts;
	}
	
	public function ChildAccounts() {
		if (is_null($this->child_accounts)) {
			$database = BeaconCommon::Database();
			$results = $database->Query('SELECT ' . implode(', ', static::SQLColumns()) . ' FROM users WHERE parent_account_id = $1;', $this->user_id);
			$this->child_accounts = static::GetFromResults($results);
			$this->has_child_accounts = count($this->child_accounts) > 0;
		}
		return $this->child_accounts;
	}
	
	public function ParentAccountID() {
		return $this->parent_account_id;
	}
	
	public function SetParentAccountID(string $parent_account_id) {
		$this->parent_account_id = $parent_account_id;
	}
	
	public function ParentAccount() {
		if (is_null($this->parent_account_id)) {
			return null;
		}
		
		return static::GetByUserID($this->parent_account_id);
	}
	
	public function TotalChildSeats() {
		if ($this->banned) {
			return 0;
		}
		
		$database = BeaconCommon::Database();
		$results = $database->Query('SELECT SUM(child_seat_count) AS total_seat_count FROM purchased_products WHERE purchaser_email = $1;', $this->email_id);
		return intval($results->Field('total_seat_count'));
	}
	
	public function UsedChildSeats() {
		$database = BeaconCommon::Database();
		$results = $database->Query('SELECT COUNT(users) AS used_seat_count FROM users WHERE parent_account_id = $1 AND enabled = TRUE;', $this->user_id);
		return intval($results->Field('used_seat_count'));
	}
	
	public function RemainingChildSeats() {
		return $this->TotalChildSeats() - $this->UsedChildSeats();
	}
	
	public function CanAddChildAccount() {
		return $this->RemainingChildSeats() > 0;
	}
	
	public function RequiresPasswordChange() {
		return $this->require_password_change;
	}
	
	public function SetRequiresPasswordChange(bool $required) {
		$this->require_password_change = $required;
	}
	
	public function IsVerified() {
		return $this->email_verified;
	}
	
	public function Is2FAProtected() {
		return false;
	}
	
	public function Verify2FACode(string $code) {
		if ($this->Is2FAProtected() === false) {
			return true;
		}
		
		return false;
	}
	
	public function Set2FAKey(string $key) {
		
	}
	
	public function jsonSerialize() {
		$arr = array(
			'user_id' => $this->user_id,
			'login_key' => $this->username,
			'username' => $this->username,
			'public_key' => $this->public_key,
			'private_key' => $this->private_key,
			'private_key_salt' => $this->private_key_salt,
			'private_key_iterations' => $this->private_key_iterations,
			'banned' => $this->banned,
			'signatures' => $this->signatures,
			'omni_version' => $this->purchased_omni_version,
			'usercloud_key' => $this->usercloud_key,
			'enabled' => $this->enabled,
			'parent_account_id' => $this->parent_account_id,
			'require_password_change' => $this->require_password_change
		);
		if (!empty($this->expiration)) {
			$arr['expiration'] = $this->expiration;
		}
		return $arr;
	}
	
	public function PrepareSignatures(string $hardware_id) {
		// version 1
		$fields = array($hardware_id, strtolower($this->UserID()), strval($this->purchased_omni_version));
		if (self::OmniFree) {
			$expires = (floor(time() / 604800) * 604800) + 2592000;
			$this->expiration = date('Y-m-d H:i:sO', $expires);
			$fields[] = $this->expiration;
		}
		$signature = '';
		if (openssl_sign(implode(' ', $fields), $signature, BeaconCommon::GetGlobal('Beacon_Private_Key'))) {
			$this->signatures['1'] = bin2hex($signature);
		}
		
		// version 2
		$fields = array($hardware_id, strtolower($this->UserID()), strval($this->purchased_omni_version), ($this->banned ? 'Banned' : 'Clean'));
		if (self::OmniFree) {
			$expires = (floor(time() / 604800) * 604800) + 2592000;
			$this->expiration = date('Y-m-d H:i:sO', $expires);
			$fields[] = $this->expiration;
		}
		$signature = '';
		if (openssl_sign(implode(' ', $fields), $signature, BeaconCommon::GetGlobal('Beacon_Private_Key'))) {
			$this->signatures['2'] = bin2hex($signature);
		}
	}
	
	public function TestPassword(string $password) {
		$private_key = $this->DecryptedPrivateKey($password);
		if (is_null($private_key)) {
			return false;
		}
		
		unset($private_key);
		return true;
	}
	
	public function ChangePassword(string $old_password, string $new_password) {
		try {
			$private_key = $this->DecryptedPrivateKey($old_password);
			if (is_null($private_key)) {
				return false;
			}
			$salt = BeaconEncryption::GenerateSalt();
			$iterations = 12000;
			$new_hash = BeaconEncryption::HashFromPassword($new_password, $salt, $iterations);
			$encrypted_private_key = bin2hex(BeaconEncryption::SymmetricEncrypt($new_hash, $private_key, false));
			$salt = bin2hex($salt);
			unset($private_key, $old_hash);
			
			$this->private_key_salt = $salt;
			$this->private_key_iterations = $iterations;
			$this->private_key = $encrypted_private_key;
			
			return true;
		} catch (Exception $e) {
			return false;
		}
	}
	
	public function ReplacePassword(string $password, string $private_key, string $usercloud_key, array &$child_account_passwords) {
		if (empty($this->email_id)) {
			return false;
		}
		
		$old_private_key = $this->private_key;
		$this->private_key = null;
		
		if ($this->AddAuthentication($this->username, $this->email_id, $password, $private_key, $usercloud_key)) {
			$children = $this->ChildAccounts();
			foreach ($children as $child) {
				$child_password = BeaconCommon::GenerateUUID();
				$temp = [];
				if ($child->ReplacePassword($child_password, $private_key, $temp)) {
					$child->SetRequiresPasswordChange(true);
					$children[$child->UserID()] = $child_password;
				}
			}
			return true;
		} else {
			$this->private_key = $old_private_key;
			return false;
		}
	}
	
	public function AddAuthentication(string $username, string $email, string $password, string $private_key, string $usercloud_key) {
		if (empty($this->private_key) == false) {
			return false;
		}
		
		try {
			if (BeaconCommon::IsUUID($email)) {
				$email_id = $email;
			} else {
				$database = BeaconCommon::Database();
				$results = $database->Query('SELECT uuid_for_email($1, TRUE) AS email_id;', $email);
				$email_id = $results->Field('email_id');
			}
			
			if (empty($username)) {
				if (empty($this->username)) {
					$database = BeaconCommon::Database();
					$results = $database->Query('SELECT generate_username() AS username;');
					$username = $results->Field('username');
				} else {
					$username = $this->username;
				}
			}
			
			$salt = BeaconEncryption::GenerateSalt();
			$iterations = 12000;
			$hash = BeaconEncryption::HashFromPassword($password, $salt, $iterations);
			$encrypted_private_key = bin2hex(BeaconEncryption::SymmetricEncrypt($hash, $private_key, false));
			$salt = bin2hex($salt);
			
			// test if the public key needs to be changed
			try {
				$test_value = BeaconCommon::GenerateUUID();
				$signature = BeaconEncryption::RSASign($private_key, $test_value);
				$verified = BeaconEncryption::RSAVerify($this->public_key, $test_value, $signature);
			} catch (Exception $e) {
				$verified = false;
			}
			if ($verified === false) {
				$new_public_key = BeaconEncryption::ExtractPublicKey($private_key);
				if (is_null($new_public_key) === false) {
					$this->public_key = $new_public_key;
				} else {
					return false;
				}
			}
			
			$this->username = $username;
			$this->email_id = $email_id;
			$this->private_key_salt = $salt;
			$this->private_key_iterations = $iterations;
			$this->private_key = $encrypted_private_key;
			$this->SetUsercloudKey($usercloud_key)
			
			return true;
		} catch (Exception $e) {
			return false;
		}
	}
	
	public function MergeUsers(... $user_ids) {
		$database = BeaconCommon::Database();
		try {
			$database->BeginTransaction();
			foreach ($user_ids as $user_id) {
				$database->Query('UPDATE sessions SET user_id = $2 WHERE user_id = $1;', $user_id, $this->user_id);
				$database->Query('UPDATE documents SET user_id = $2 WHERE user_id = $1;', $user_id, $this->user_id);
				$database->Query('UPDATE guest_documents SET user_id = $2 WHERE user_id = $1;', $user_id, $this->user_id);
				$database->Query('UPDATE mods SET user_id = $2 WHERE user_id = $1;', $user_id, $this->user_id);
				$database->Query('UPDATE oauth_tokens SET user_id = $2 WHERE user_id = $1;', $user_id, $this->user_id);
				$database->Query('DELETE FROM users WHERE user_id = $1;', $user_id);
			}
			$database->Commit();
			return true;
		} catch (Exception $e) {
			return false;
		}
	}
	
	public function Commit() {
		$original_user = BeaconUser::GetByUserID($this->user_id);
		$changes = array();
		$database = BeaconCommon::Database();
		
		if (is_null($original_user)) {
			$changes['user_id'] = $this->user_id;
			$changes['username'] = $this->username;
			$changes['email_id'] = $this->email_id;
			$changes['public_key'] = $this->public_key;
			$changes['private_key'] = $this->private_key;
			$changes['private_key_salt'] = $this->private_key_salt;
			$changes['private_key_iterations'] = $this->private_key_iterations;
			$changes['usercloud_key'] = $this->usercloud_key;
			$changes['require_password_change'] = $this->require_password_change;
			$changes['enabled'] = $this->enabled;
			$changes['parent_account_id'] = $this->parent_account_id;
			try {
				$database->Insert('users', $changes);
			} catch (Exception $e) {
				return false;
			}
		} else {
			$keys = array('username', 'email_id', 'public_key', 'private_key', 'private_key_salt', 'private_key_iterations', 'usercloud_key', 'require_password_change', 'enabled', 'parent_account_id');
			foreach ($keys as $key) {
				if ($this->$key !== $original_user->$key) {
					$changes[$key] = $this->$key;
				}
			}
			if (count($changes) == 0) {
				return true;
			}
			try {
				$database->BeginTransaction();
				$database->Update('users', $changes, array('user_id' => $this->user_id));
				if (array_key_exists('private_key', $changes)) {
					$database->Query('DELETE FROM email_verification WHERE email_id = $1;', $this->email_id);
					$database->Query('DELETE FROM sessions WHERE user_id = $1;', $this->user_id);
				}
				
				if ($this->IsChildAccount() === false && array_key_exists('usercloud_key', $changes)) {
					// The cloud key has been changed, so we need to cleanup the cloud files
					$cloud_files = BeaconCloudStorage::ListFiles('/' . $this->UserID() . '/');
					foreach ($cloud_files as $file) {
						if ($file['deleted'] === false && is_null($file['header']) === false) {
							BeaconCloudStorage::DeleteFile($file['path']);
						}
					}
				}
				
				$database->Commit();
			} catch (Exception $e) {
				return false;
			}
		}
		
		// Also commit child accounts. Caching allows this to work correctly.
		$children = $this->ChildAccounts();
		foreach ($children as $child) {
			$child->Commit();
		}
		
		return true;
	}
	
	public function Delete() {
		// Can only delete child accounts
		if ($this->IsChildAccount() === false) {
			return false;
		}
		
		$database = BeaconCommon::Database();
		try {
			$database->BeginTransaction();
			$database->Query('DELETE FROM users WHERE user_id = $1;', $this->user_id);
			$database->Commit();
			return true;
		} catch (Exception $e) {
			return false;
		}
	}
	
	public function CheckSignature(string $data, string $signature) {
		return BeaconEncryption::RSAVerify($this->public_key, $data, $signature);
	}
	
	public function UsercloudKey() {
		return $this->usercloud_key;
	}
	
	public function SetUsercloudKey(string $key) {
		$this->usercloud_key = $key;
	}
	
	public function DecryptedUsercloudKey(string $private_key) {
		return BeaconEncryption::RSADecrypt($private_key, hex2bin($this->usercloud_key));
	}
	
	public function SetDecryptedUsercloudKey(string $key) {
		$this->usercloud_key = bin2hex(BeaconEncryption::RSAEncrypt($this->public_key, $key));
	}
	
	private static function SQLColumns() {
		return array('users.user_id', 'users.email_id', 'users.username', 'users.public_key', 'users.private_key', 'users.private_key_salt', 'users.private_key_iterations', 'users.usercloud_key', 'users.banned', 'users.enabled', 'users.parent_account_id', 'users.require_password_change', 'COALESCE(email_addresses.verified, FALSE) AS email_verified');
	}
	
	private static function GenerateUsercloudKey() {
		return random_bytes(128);
	}
	
	public static function GetByEmail(string $email) {
		// When doing a SELECT with uuid_for_email(email, create), you must wrap it in its own SELECT statement.
		// This is because the function is VOLATILE and will be executed for every row in the user table unless
		// treated as a subquery. Or omit the second parameter, which is a STABLE function and performs fine.
		// The second parameter should only be used when updating the email row is desired.
		$database = BeaconCommon::Database();
		$results = $database->Query('SELECT ' . implode(', ', static::SQLColumns()) . ' FROM users LEFT JOIN email_addresses ON (users.email_id = email_addresses.email_id) WHERE users.email_id IS NOT NULL AND users.email_id = (SELECT uuid_for_email($1, FALSE));', $email);
		$users = static::GetFromResults($results);
		if (count($users) == 1) {
			return $users[0];
		}
	}
	
	public static function GetByUserID(string $user_id) {
		$database = BeaconCommon::Database();
		$results = $database->Query('SELECT ' . implode(', ', static::SQLColumns()) . ' FROM users LEFT JOIN email_addresses ON (users.email_id = email_addresses.email_id) WHERE users.user_id = ANY($1);', '{' . $user_id . '}');
		$users = static::GetFromResults($results);
		if (count($users) == 1) {
			return $users[0];
		}
	}
	
	public static function GetByExtendedUsername(string $username) {
		$display_name = substr($username, 0, -9);
		$suffix = strtolower(substr($username, -8));
		
		$database = BeaconCommon::Database();
		$results = $database->Query('SELECT ' . implode(', ', static::SQLColumns()) . ' FROM users LEFT JOIN email_addresses ON (users.email_id = email_addresses.email_id) WHERE users.username = $1 AND SUBSTRING(LOWER(users.user_id::TEXT) FROM 1 FOR 8) = $2;', $display_name, $suffix);
		$users = static::GetFromResults($results);
		if (count($users) == 1) {
			return $users[0];
		}
	}
	
	protected static function GetFromResults(BeaconRecordSet $results) {
		if ($results === null || $results->RecordCount() === 0) {
			return array();
		}
		
		$users = array();
		while (!$results->EOF()) {
			$user = new static($results);
			$users[] = $user;
			$results->MoveNext();
		}
		return $users;
	}
	
	public static function ValidateEmail(string $email) {
		return filter_var($email, FILTER_VALIDATE_EMAIL);
	}
	
	public static function ValidatePassword(string $password) {
		$passlen = strlen($password);
		
		if ($passlen < 8) {
			return false;
		}
		
		$chars = count_chars($password);
		foreach ($chars as $char => $count) {
			$percent = $count / $passlen;
			if ($percent > 0.3) {
				return false;
			}
		}
		
		return true;
	}
	
	public static function IsExtendedUsername(string $username) {
		return preg_match('/#[a-fA-F0-9]{8}$/', $username) === 1;
	}
	
	public function HasFiles() {
		$database = BeaconCommon::Database();
		$results = $database->Query('SELECT COUNT(remote_path) AS num_files FROM usercloud WHERE remote_path LIKE $1 AND size_in_bytes > 0 AND deleted = FALSE;', '/' . $this->CloudUserID() . '/%');
		return $results->Field('num_files') > 0;
	}
	
	public function HasEncryptedFiles() {
		$database = BeaconCommon::Database();
		$results = $database->Query('SELECT COUNT(remote_path) AS num_files FROM usercloud WHERE remote_path LIKE $1 AND size_in_bytes > 0 AND deleted = FALSE AND header IS NOT NULL;', '/' . $this->CloudUserID() . '/%');
		return $results->Field('num_files') > 0;
	}
}

?>
