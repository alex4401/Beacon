<?php

abstract class CommonBeaconUser implements JsonSerializable {
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
			
			if ($this->enabled === true) {
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
	
	abstract function CloudUserID();
	
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
	
	public function PublicKey() {
		return $this->public_key;
	}
	
	public function PrivateKey() {
		return $this->private_key;
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
	
	public function IsChildAccount() {
		return is_null($this->parent_account_id) === false;
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
			'usercloud_key' => $this->usercloud_key
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
	
	// Incomplete
}

?>