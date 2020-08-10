<?php

interface BeaconUserInterface extends JsonSerializable {
	public function __construct($source = null);
	public function UserID();
	public function Suffix();
	public function LoginKey();
	public function Username();
	public function PublicKey();
	public function PrivateKey();
	public function PrivateKeySalt();
	public function PrivateKeyIterations();
	public function IsAnonymous();
	public function IsEnabled();
	public function IsChildAccount();
	public function PrepareSignatures(string $hardware_id);
	public function TestPassword(string $password);
	public function MergeUsers(... $user_ids);
	public function Commit();
	public function CheckSignature(string $data, string $signature);
	public function AssignUsercloudKey();
	public function HasFiles();
	public function HasEncryptedFiles();
	
	public static function GetByEmail(string $email);
	public static function GetByUserID(string $user_id);
	public static function GetByExtendedUsername(string $username);
	public static function ValidateEmail(string $email);
	public static function IsExtendedUsername(string $username);
}

?>