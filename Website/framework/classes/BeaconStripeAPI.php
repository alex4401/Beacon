<?php

class BeaconStripeAPI {
	private $api_secret = '';
	
	public function __construct(string $api_secret) {
		$this->api_secret = $api_secret;
	}
	
	public function GetPaymentIntent(string $intent_id) {
		$curl = curl_init('https://api.stripe.com/v1/payment_intents/' . $intent_id);
		$headers = array('Authorization: Bearer ' . $this->api_secret);
		curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
		$pi_body = curl_exec($curl);
		$pi_status = curl_getinfo($curl, CURLINFO_HTTP_CODE);
		curl_close($curl);
		
		if ($pi_status != 200) {
			return null;
		}
		$pi_json = json_decode($pi_body, true);
		if (is_null($pi_json)) {
			return null;
		}
		
		return $pi_json;
	}
	
	public function GetPaymentSource(string $source_id) {
		$curl = curl_init('https://api.stripe.com/v1/sources/' . $source_id);
		$headers = array('Authorization: Bearer ' . $this->api_secret);
		curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
		$source_body = curl_exec($curl);
		$source_status = curl_getinfo($curl, CURLINFO_HTTP_CODE);
		curl_close($curl);
		
		if ($source_status != 200) {
			return null;
		}
		$source_json = json_decode($source_body, true);
		if (is_null($source_json)) {
			return null;
		}
		
		return $source_json;
	}
	
	public function GetCustomer(string $customer_id) {
		$curl = curl_init('https://api.stripe.com/v1/customers/' . $customer_id);
		$headers = array('Authorization: Bearer ' . $this->api_secret);
		curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
		$customer_body = curl_exec($curl);
		$customer_status = curl_getinfo($curl, CURLINFO_HTTP_CODE);
		curl_close($curl);
		
		if ($customer_status != 200) {
			return null;
		}
		$customer_json = json_decode($customer_body, true);
		if (is_null($customer_json)) {
			return null;
		}
		
		return $customer_json;
	}
	
	public function UpdateCustomer(string $customer_id, array $fields) {
		$curl = curl_init('https://api.stripe.com/v1/customers/' . $customer_id);
		$headers = array('Authorization: Bearer ' . $this->api_secret);
		curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($curl, CURLOPT_POST, 1);
		curl_setopt($curl, CURLOPT_POSTFIELDS, http_build_query($fields));
		$customer_body = curl_exec($curl);
		$customer_status = curl_getinfo($curl, CURLINFO_HTTP_CODE);
		curl_close($curl);
		
		return ($customer_status == 200);
	}
	
	public function EmailForPaymentIntent(string $intent_id) {
		$cache_key = 'email_' . $intent_id;
		$email = BeaconCache::Get($cache_key);
		if (!is_null($email)) {
			return $email;
		}
		
		$pi_json = $this->GetPaymentIntent($intent_id);
		if (is_null($pi_json)) {
			return null;
		}
		if (array_key_exists('customer', $pi_json) == false || empty($pi_json['customer'])) {
			return null;
		}
		
		$customer_id = $pi_json['customer'];
		$customer_json = $this->GetCustomer($customer_id);
		if (is_null($customer_json)) {
			return null;
		}
		
		$email = $customer_json['email'];
		BeaconCache::Set($cache_key, $email, 3600);
		return $email;
	}
	
	public function ChangeEmailForPaymentIntent(string $intent_id, string $new_email) {
		$cache_key = 'email_' . $intent_id;
		
		$pi_json = $this->GetPaymentIntent($intent_id);
		if (is_null($pi_json)) {
			return false;
		}
		
		if (array_key_exists('customer', $pi_json) == false || empty($pi_json['customer'])) {
			return false;
		}
		
		$customer_id = $pi_json['customer'];
		$customer_json = $this->GetCustomer($customer_id);
		if (is_null($customer_json)) {
			return false;
		}
		
		if (strtolower($customer_json['email']) == strtolower($new_email)) {
			return true;
		}
		
		if (!$this->UpdateCustomer($customer_id, array('email' => $new_email))) {
			return false;
		}
		
		BeaconCache::Set($cache_key, $new_email, 3600);
		return true;
	}
}

?>