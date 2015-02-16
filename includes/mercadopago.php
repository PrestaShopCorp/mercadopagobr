<?php

/**
 * MercadoPago Integration Library
 * Access MercadoPago for payments integration
 * 
 * @author hcasatti
 *
 */
$GLOBALS['LIB_LOCATION'] = dirname(__FILE__);

class MP {

	const VERSION = '0.2.1';

	private $client_id;
	private $client_secret;
	private $access_data;
	private $sandbox = false;

	public function __construct($client_id, $client_secret)
	{
		$this->client_id = $client_id;
		$this->client_secret = $client_secret;
	}

	/**
	 * Get Access Token for API use
	 */
	public function getAccessToken()
	{
		$app_client_values = $this->buildQuery(array(
			'client_id' => $this->client_id,
			'client_secret' => $this->client_secret,
			'grant_type' => 'client_credentials'
				));

		$access_data = MPRestClient::post('/oauth/token', $app_client_values, 'application/x-www-form-urlencoded');

		$this->access_data = $access_data['response'];

		return $this->access_data['access_token'];
	}

	public function validatePublicKey($public_key)
	{
		$public_key_result = MPRestClient::get('/checkout/custom/public_key/'.$public_key);
		$public_key_result = $public_key_result['response'];
		return isset($public_key_result) && array_key_exists('client_id', $public_key_result)
					&& $public_key_result['client_id'] == $this->client_id ? true : false;
	}

	/**
	 * Get information for specific payment
	 * @param int $id
	 * @return array(json)
	 */
	public function getPayment($id)
	{
		$access_token = $this->getAccessToken();

		$uri_prefix = $this->sandbox ? '/sandbox' : '';
		$payment_info = MPRestClient::get($uri_prefix.'/collections/notifications/'.$id.'?access_token='.$access_token);
		return $payment_info;
	}

	/**
	 * Create a checkout preference
	 * @param array $preference
	 * @return array(json)
	 */
	public function createPreference($preference)
	{
		$access_token = $this->getAccessToken();

		$preference_result = MPRestClient::post('/checkout/preferences?access_token='.$access_token, $preference);
		return $preference_result;
	}

	public function createCustomPayment($info)
	{
		$access_token = $this->getAccessToken();
		$preference_result = MPRestClient::post('/checkout/custom/create_payment?access_token='.$access_token, $info);
		return $preference_result;
	}

	public static function getCategories()
	{
		$response = MPRestClient::get('/item_categories');
		$response = $response['response'];
		return $response;
	}

	private function buildQuery($params)
	{
		if (function_exists('http_build_query'))
			return http_build_query($params, '', '&');
		else
		{
			$elements = array ();
			foreach ($params as $name => $value)
				$elements[] = '{$name}='.urlencode($value);
			return implode('&', $elements);
		}
	}

}

/**
 * MercadoPago cURL RestClient
 */
class MPRestClient {

	const API_BASE_URL = 'https://api.mercadolibre.com';

	private static function getConnect($uri, $method, $content_type)
	{
		$connect = curl_init(self::API_BASE_URL.$uri);

		curl_setopt($connect, CURLOPT_USERAGENT, 'MercadoPago PHP SDK v'.MP::VERSION);
		curl_setopt($connect, CURLOPT_CAINFO, $GLOBALS['LIB_LOCATION'].'/cacert.pem');
		curl_setopt($connect, CURLOPT_SSLVERSION, 3);
		curl_setopt($connect, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($connect, CURLOPT_CUSTOMREQUEST, $method);
		curl_setopt($connect, CURLOPT_HTTPHEADER, array('Accept: application/json', 'Content-Type: '.$content_type));

		return $connect;
	}

	private static function setData(&$connect, $data, $content_type)
	{
		if ($content_type == 'application/json')
		{
			if (gettype($data) == 'string')
				Tools::jsonDecode($data, true);
			else
				$data = Tools::jsonEncode($data);

			if (function_exists('json_last_error'))
			{
				$json_error = json_last_error();
				if ($json_error != JSON_ERROR_NONE)
					throw new Exception('JSON Error [{$json_error}] - Data: {$data}');
			}
		}

		curl_setopt($connect, CURLOPT_POSTFIELDS, $data);
	}

	private static function exec($method, $uri, $data, $content_type)
	{
		$connect = self::getConnect($uri, $method, $content_type);
		if ($data)
			self::setData($connect, $data, $content_type);

		$api_result = curl_exec($connect);
		$api_http_code = curl_getinfo($connect, CURLINFO_HTTP_CODE);

		$response = array(
			'status' => $api_http_code,
			'response' => Tools::jsonDecode($api_result, true)
		);

		// if ($response['status'] >= 400)
		// 	throw new Exception ($response['response']['message'], $response['status']);

		curl_close($connect);

		return $response;
	}

	public static function get($uri, $content_type = 'application/json')
	{
		return self::exec('GET', $uri, null, $content_type);
	}

	public static function post($uri, $data, $content_type = 'application/json')
	{
		return self::exec('POST', $uri, $data, $content_type);
	}

	public static function put($uri, $data, $content_type = 'application/json')
	{
		return self::exec('PUT', $uri, $data, $content_type);
	}

}

?>
