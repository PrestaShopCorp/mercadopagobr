{**
* 2007-2015 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Open Software License (OSL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/osl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author    ricardobrito
*  @copyright Copyright (c) MercadoPago [http://www.mercadopago.com]
*  @license   http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
*  International Registered Trademark & Property of MercadoPago
*}

<h4>
	<strong>
		{if $status_detail eq 'accredited'}
		{l s='Thank for your purchase!' mod='mercadopago'}</br>
		{l s='Your payment was accredited.' mod='mercadopago'}
	</strong>
	</br>
	</br>
	<h5>
		{l s='Card holder name: ' mod='mercadopago'}
		{$card_holder_name|escape:'htmlall'}</br>
		{l s='Credit card: ' mod='mercadopago'}
		**** **** **** {$four_digits|escape:'htmlall'}</br>
		{l s='Payment method: ' mod='mercadopago'}
		{$payment_method_id|escape:'htmlall'}</br>
		{if $expiration_date != null}
			{l s='Expiration date: ' mod='mercadopago'}
			{$expiration_date|escape:'htmlall'}</br>
		{/if}
		{l s='Amount: ' mod='mercadopago'}
		{$amount|escape:'htmlall'}</br>
		{if $installments != null}
			{l s='Installments: ' mod='mercadopago'}
			{$installments|escape:'htmlall'}</br>
		{/if}
		{l s='Statement descriptor: ' mod='mercadopago'}
		{$statement_descriptor|escape:'htmlall'}</br>
		{l s='Payment id (MercadoPago): ' mod='mercadopago'}
		{$payment_id|escape:'htmlall'}</br>
	</h5>
	{elseif $status_detail eq 'pending_review_manual' || $status_detail eq 'pending_review'}
		{l s='We are processing the payment. In less than 2 business days we will tell you by e-mail if it is accredited or if we need more information.' mod='mercadopago'}
	{elseif $status_detail eq 'pending_contingency'}
		{l s='We are processing the payment. In less than an hour we will send you by e-mail the result.' mod='mercadopago'}
	{elseif $payment_status eq 'rejected'}
		{l s='O seu pagamento foi rejeitado.' mod='mercadopago'}</br>
		{if $status_detail eq 'cc_rejected_bad_filled_card_number'}
			{l s='Check the card number.' mod='mercadopago'}
		
		{elseif $status_detail eq 'cc_rejected_bad_filled_date'}
			{l s='Check the expiration date.' mod='mercadopago'}
		
		{elseif $status_detail eq 'cc_rejected_bad_filled_other'}
			{l s='Check the data.' mod='mercadopago'}
		
		{elseif $status_detail eq 'cc_rejected_bad_filled_security_code'}
			{l s='Check the security code.' mod='mercadopago'}

		{elseif $status_detail eq 'cc_rejected_blacklist'}
			{l s='We could not process your payment.' mod='mercadopago'}

		{elseif $status_detail eq 'cc_rejected_call_for_authorize'}
			{l s='You must authorize to ' mod='mercadopago'}
			{$payment_method_id|escape:'htmlall'}
			{l s=' the payment to MercadoPago' mod='mercadopago'}

		{elseif $status_detail eq 'cc_rejected_card_disabled'}
			{l s='Call ' mod='mercadopago'}
			{$payment_method_id|escape:'htmlall'}
			{l s=' to activate your card. The phone is on the back of your card.' mod='mercadopago'}

		{elseif $status_detail eq 'cc_rejected_card_error'}
			{l s='We could not process your payment.' mod='mercadopago'}

		{elseif $status_detail eq 'cc_rejected_duplicated_payment'}
			{l s='You already made a payment by that value. If you need to repay, use another card or other payment method.' mod='mercadopago'}

		{elseif $status_detail eq 'cc_rejected_high_risk'}
			{l s='Your payment was rejected. Choose another payment method, we recommend cash methods.' mod='mercadopago'} 

		{elseif $status_detail eq 'cc_rejected_insufficient_amount'}
			{l s='Your ' mod='mercadopago'}
			{$payment_method_id|escape:'htmlall'}
			{l s=' do not have sufficient funds.' mod='mercadopago'} 

		{elseif $status_detail eq 'cc_rejected_invalid_installments'}
			{$payment_method_id|escape:'htmlall'}
			{l s=' does not process payments in ' mod='mercadopago'}
			{$installments|escape:'htmlall'}
			{l s=' installments.' mod='mercadopago'}

		{elseif $status_detail eq 'cc_rejected_max_attempts'}
			{l s='You have got to the limit of allowed attempts. Choose another card or another payment method.' mod='mercadopago'}

		{elseif $status_detail eq 'cc_rejected_other_reason'}
			{$payment_method_id|escape:'htmlall'}
			{l s=' did not process the payment.' mod='mercadopago'}
		{/if}
	{elseif $payment_id eq null && $payment_type eq null}
		{l s='The payment of ' mod='mercadopago'}
		{$amount|escape:'htmlall'}
		{l s=' failed.' mod='mercadopago'}
	{elseif status_detail eq 'expired'}
		{l s='Payment expired.' mod='mercadopago'}
	{/if}
</h4>
</br>
<span class="footer-logo"></span>