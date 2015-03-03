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

<link rel="stylesheet" type="text/css" href="{$this_path_ssl|escape:'htmlall'}modules/mercadopago/views/css/mercadopago_v6.css">
<h4>
	<strong>
		{if $status_detail eq 'accredited'}
		{l s='Obrigado pela sua compra!' mod='mercadopago'}</br>
		{l s='O seu pagamento foi aprovado.' mod='mercadopago'}
	</strong>
	</br>
	<h5>
		{l s='Titular do cartão de crédito: ' mod='mercadopago'}
		{$card_holder_name|escape:'htmlall'}</br>
		{l s='Cartão de crédito: ' mod='mercadopago'}
		**** **** **** {$four_digits|escape:'htmlall'}</br>
		{l s='Método de Pagamento: ' mod='mercadopago'}
		{$payment_method_id|escape:'htmlall'}</br>
		{if $expiration_date != null}
			{l s='Data de Expiração: ' mod='mercadopago'}
			{$expiration_date|escape:'htmlall'}</br>
		{/if}
		{l s='Valor: ' mod='mercadopago'}
		{$amount|escape:'htmlall'}</br>
		{if $installments != null}
			{l s='Parcelas: ' mod='mercadopago'}
			{$installments|escape:'htmlall'}</br>
		{/if}
		{l s='Identificação na Fatura: ' mod='mercadopago'}
		{$statement_descriptor|escape:'htmlall'}</br>
		{l s='Numero de pagamento (MercadoPago): ' mod='mercadopago'}
		{$payment_id|escape:'htmlall'}</br>
	</h5>
	{elseif $status_detail eq 'pending_review_manual'}
		{l s='O seu pagamento está pendente. Estamos processando o pagamento.
	Em menos de 2 dias úteis você será avisado por e-mail se foi creditado ou se precisarmos de mais informações.' mod='mercadopago'}
	{elseif $status_detail eq 'pending_contingency'}
		{l s='O seu pagamento está pendente. Estamos processando o pagamento. Em menos de 1 hora, nós enviaremos o resultado por e-mail.' mod='mercadopago'}
	{elseif $payment_status eq 'rejected'}
		{l s='O seu pagamento foi rejeitado.' mod='mercadopago'}</br>
		{if $status_detail eq 'cc_rejected_bad_filled_card_number'}
			{l s='Verifique o número do cartão.' mod='mercadopago'}
		
		{elseif $status_detail eq 'cc_rejected_bad_filled_date'}
			{l s='Verifique a data de validade.' mod='mercadopago'}
		
		{elseif $status_detail eq 'cc_rejected_bad_filled_other'}
			{l s='Revise os dados.' mod='mercadopago'}
		
		{elseif $status_detail eq 'cc_rejected_bad_filled_security_code'}
			{l s='Revise o código de segurança.' mod='mercadopago'}

		{elseif $status_detail eq 'cc_rejected_blacklist'}
			{l s='Não foi possível processar o pagamento.' mod='mercadopago'}

		{elseif $status_detail eq 'cc_rejected_call_for_authorize'}
			{l s='Você precisa autorizar com ' mod='mercadopago'}
			{$payment_method_id|escape:'htmlall'}
			{l s=' o pagamento ao MercadoPago' mod='mercadopago'}

		{elseif $status_detail eq 'cc_rejected_card_disabled'}
			{l s='Ligue para ' mod='mercadopago'}
			{$payment_method_id|escape:'htmlall'}
			{l s=' e ative o seu cartão. O telefone está no verso do seu cartão de crédito.' mod='mercadopago'}

		{elseif $status_detail eq 'cc_rejected_card_error'}
			{l s='Não foi possível processar o pagamento.' mod='mercadopago'}

		{elseif $status_detail eq 'cc_rejected_duplicated_payment'}
			{l s='O seu pagamento foi recusado. Recomendamos que você pague com outro dos meios de pagamento oferecidos, preferencialmente à vista.' mod='mercadopago'}

		{elseif $status_detail eq 'cc_rejected_insufficient_amount'}
			{l s='O seu ' mod='mercadopago'}
			{$payment_method_id|escape:'htmlall'}
			{l s=' não tem limite suficiente.' mod='mercadopago'} 

		{elseif $status_detail eq 'cc_rejected_invalid_installments'}
			{$payment_method_id|escape:'htmlall'}
			{l s=' não processa pagamentos em ' mod='mercadopago'}
			{$installments|escape:'htmlall'}
			{l s=' parcelas.' mod='mercadopago'}

		{elseif $status_detail eq 'cc_rejected_max_attempts'}
			{l s='Você atingiu o limite de tentativas permitidas. Use outro cartão ou outro meio de pagamento.' mod='mercadopago'}

		{elseif $status_detail eq 'cc_rejected_other_reason'}
			{$payment_method_id|escape:'htmlall'}
			{l s=' não processou o pagamento.' mod='mercadopago'}
		{/if}
	{elseif $payment_id eq null && $payment_type eq null}
		{l s='O pagamento no valor de ' mod='mercadopago'}
		{$amount|escape:'htmlall'}
		{l s='não foi finalizado.' mod='mercadopago'}
	{elseif status_detail eq 'expired'}
		{l s='O pagamento foi expirado.' mod='mercadopago'}
	{/if}
</h4>
</br>
<span style="background: url({$this_path_ssl|escape:'htmlall'}modules/mercadopago/views/img/payment_method_logo.png) no-repeat;" class="footer-logo"></span>