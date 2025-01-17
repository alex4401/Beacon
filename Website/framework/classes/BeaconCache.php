<?php

abstract class BeaconCache {
	protected static $mem = null;
	
	protected static function Init() {
		if (is_null(static::$mem)) {
			static::$mem  = new Memcached();
			static::$mem->addServer('127.0.0.1', 11211);
		}
	}
	
	public static function Get(string $key) {
		static::Init();
		$key = BeaconCommon::EnvironmentName() . '.' . $key;
		$value = static::$mem->get($key);
		$status = static::$mem->getResultCode();
		if ($status == 0) {
			return $value;
		} elseif ($status == 16) {
			return null;
		} else {
			throw new Exception('Memcached Error: ' . $status);
		}
	}
	
	public static function Set(string $key, $value, $ttl = 0) {
		static::Init();
		$key = BeaconCommon::EnvironmentName() . '.' . $key;
		static::$mem->set($key, $value, $ttl);
		$status = static::$mem->getResultCode();
		if ($status != 0) {
			throw new Exception('Memcached Error: ' . $status);
		}
	}
	
	public static function Remove(string $key) {
		static::Init();
		$key = BeaconCommon::EnvironmentName() . '.' . $key;
		static::$mem->delete($key, $value);
		$status = static::$mem->getResultCode();
		if ($status != 0) {
			throw new Exception('Memcached Error: ' . $status);
		}
	}
}

?>