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
<div class="mp-module">
	{include file='./marketing.tpl' this_path_ssl=$this_path_ssl|escape:'htmlall'}
	<div id="settings">
	<div id="alerts">
	{if $version eq 6}
		{if $success eq 'true'}
		<div id="alert" class="bootstrap">
			<div class="alert alert-success">
				<button type="button" class="close" data-dismiss="alert">×</button>
				{l s='Settings changed successfully.' mod='mercadopagobr'}
			</div>
		</div>
		{elseif $errors|@count > 0}
			{foreach from=$errors item=error}
			<div class="bootstrap">
				<div class="alert alert-danger">
					<button type="button" class="close" data-dismiss="alert">×</button>
					{l s='Settings failed to change.' mod='mercadopagobr'}
				</div>
			</div>
			<div class="bootstrap">
				<div class="alert alert-danger">
					<button type="button" class="close" data-dismiss="alert">×</button>
					{$error|escape:'htmlall'}
				</div>
			</div>
			{/foreach}
		{/if}
	{elseif $version eq 5}
		{if $success eq 'true'}
			<div class="conf">
				{l s='Settings changed successfully.' mod='mercadopagobr'}
			</div>
		</div>
		{elseif $errors|@count > 0}
			<div class="error">
				{l s='Settings failed to change.' mod='mercadopagobr'}
			</div>
			{foreach from=$errors item=error}
			<div class="error">
				{$error|escape:'htmlall'}	
			</div>
			{/foreach}
		{/if}
	{/if}
	</div>
	<img class="logo" src="{$this_path_ssl|escape:'htmlall'}modules/mercadopagobr/views/img/payment_method_logo_large.png">
	</br>
	</br>
	</br>
	<h3> {l s='Notes:' mod='mercadopagobr'}</h3>
	<h4> {l s='- To obtain your Client Id and Client Secret please click on your country: ' mod='mercadopagobr'}
		<a href="https://www.mercadopago.com/mlb/ferramentas/aplicacoes"><u>{l s='Brazil' mod='mercadopagobr'}</u></a> |
		<a href="https://www.mercadopago.com/mla/herramientas/aplicaciones"><u>{l s='Argentina' mod='mercadopagobr'}</u></a> |
		<a href="https://www.mercadopago.com/mlm/herramientas/aplicaciones"><u>{l s='Mexico' mod='mercadopagobr'}</u></a> | 
		<a href="https://www.mercadopago.com/mlv/herramientas/aplicaciones"><u>{l s='Venezuela' mod='mercadopagobr'}</u></a> |
		<a href="https://www.mercadopago.com/mco/herramientas/aplicaciones"><u>{l s='Colombia' mod='mercadopagobr'}</u></a> |
		<a href="https://www.mercadopago.com/mlc/herramientas/aplicaciones"><u>{l s='Chile' mod='mercadopagobr'}</u></a>
	</h4>
	{if $country eq "MLB"}
		<h4> {l s='- Get your public_key in the following address: https://www.mercadopago.com/mlb/account/credentials' mod='mercadopagobr'}</h4>
	{elseif $country eq "MLM"}
		<h4> {l s='- Get your public_key in the following address: https://www.mercadopago.com/mlm/account/credentials' mod='mercadopagobr'}</h4>
	{elseif $country eq "MLA"}
		<h4> {l s='- Get your public_key in the following address: https://www.mercadopago.com/mla/account/credentials' mod='mercadopagobr'}</h4>
	{elseif $country eq "MLC"}
		<h4> {l s='- Get your public_key in the following address: https://www.mercadopago.com/mlc/account/credentials' mod='mercadopagobr'}</h4>
	{elseif $country eq "MCO"}
		<h4> {l s='- Get your public_key in the following address: https://www.mercadopago.com/mco/account/credentials' mod='mercadopagobr'}</h4>
	{elseif $country eq "MLV"}
		<h4> {l s='- Get your public_key in the following address: https://www.mercadopago.com/mlv/account/credentials' mod='mercadopagobr'}</h4>
	{/if}
	<form action="{$uri|escape:'htmlall'}" method="post">
		<fieldset>
			<legend>
				<img src="../img/admin/contact.gif" />{l s='Settings - General' mod='mercadopagobr'}
			</legend>
			<label>{l s='Client Id:' mod='mercadopagobr'}</label>
			<div class="">
				<input type="text" size="33" name="MERCADOPAGO_CLIENT_ID" value="{$client_id|escape:'htmlall'}" />
			</div>
			<br />
			<label>{l s='Client Secret:' mod='mercadopagobr'}</label>
			<div class="">
				<input type="text" size="33" name="MERCADOPAGO_CLIENT_SECRET" value="{$client_secret|escape:'htmlall'}" />
			</div>
			<br />
			{if !empty($country)}
			<label>{l s='Category:' mod='mercadopagobr'}</label>
				<div class=""> 
					<select name="MERCADOPAGO_CATEGORY" id="category">
						 <option value="art">{l s='Collectibles & Art' mod='mercadopagobr'}</option>
						 <option value="baby">{l s='Toys for Baby, Stroller, Stroller Accessories, Car Safety Seats' mod='mercadopagobr'}</option>
						 <option value="coupons">{l s='Coupons' mod='mercadopagobr'}</option>
						 <option value="donations">{l s='Donations' mod='mercadopagobr'}</option>
						 <option value="computing">{l s='Computers & Tablets' mod='mercadopagobr'}</option>
						 <option value="cameras">{l s='Cameras & Photography' mod='mercadopagobr'}</option>
						 <option value="video_games">{l s='Video Games & Consoles' mod='mercadopagobr'}</option>
						 <option value="television">{l s='LCD, LED, Smart TV, Plasmas, TVs' mod='mercadopagobr'}</option>
						 <option value="car_electronics">{l s='Car Audio, Car Alarm Systems & Security, Car DVRs, Car Video Players, Car PC' mod='mercadopagobr'}</option>
						 <option value="electronics">{l s='Audio & Surveillance, Video & GPS, Others' mod='mercadopagobr'}</option>
						 <option value="automotive">{l s='Parts & Accessories' mod='mercadopagobr'}</option>
						 <option value="entertainment">{l s='Music, Movies & Series, Books, Magazines & Comics, Board Games & Toys' mod='mercadopagobr'}</option>
						 <option value="fashion">{l s='Men\'s, Women\'s, Kids & baby, Handbags & Accessories, Health & Beauty, Shoes, Jewelry & Watches' mod='mercadopagobr'}</option>
						 <option value="games"> {l s='Online Games & Credits' mod='mercadopagobr'}</option>
						 <option value="home">{l s='Home appliances. Home & Garden' mod='mercadopagobr'}</option>
						 <option value="musical">{l s='Instruments & Gear' mod='mercadopagobr'}</option>
						 <option value="phones">{l s='Cell Phones & Accessories' mod='mercadopagobr'}</option>
						 <option value="services">{l s='General services' mod='mercadopagobr'}</option>
						 <option value="learnings" >{l s='Trainings, Conferences, Workshops' mod='mercadopagobr'}</option>
						 <option value="tickets">{l s='Tickets for Concerts, Sports, Arts, Theater, Family, Excursions tickets, Events & more' mod='mercadopagobr'}</option>
						 <option value="travels">{l s='Plane tickets, Hotel vouchers, Travel vouchers' mod='mercadopagobr'}</option>
						 <option value="virtual_goods">{l s='E-books, Music Files, Software, Digital Images,  PDF Files and any item which can be electronically stored in a file, Mobile Recharge, DTH Recharge and any Online Recharge' mod='mercadopagobr'}</option>
						 <option value="others" selected="selected">{l s='Other categories' mod='mercadopagobr'}</option>
					</select>	
				</div>
			{/if}
				<br/>
				<label>{l s='Notification URL' mod='mercadopagobr'}:</label>
				<div>{$notification_url|escape:'javascript'}</div>

				<br />					
		</fieldset>
		{if $country == 'MLB' || $country == 'MLM' || $country == 'MLA' || $country == 'MLC' || $country == 'MCO' || $country == 'MLV'}
			<fieldset>
				<legend>
					<img src="../img/admin/contact.gif" />{l s='Settings - Custom Credit Card' mod='mercadopagobr'}
				</legend>
				<label>{l s='Active: ' mod='mercadopagobr'}</label>
				<div class="">
					<select name="MERCADOPAGO_CREDITCARD_ACTIVE" id="creditcard_active">
						<option value="true">{l s='Yes' mod='mercadopagobr'}</option>
						<option value="false">{l s='No' mod='mercadopagobr'} </option>
					</select>
				</div>
				<br />	
				<label>{l s='Public Key:' mod='mercadopagobr'}</label>
				<div class="">
					<input type="text" size="33" name="MERCADOPAGO_PUBLIC_KEY" value="{$public_key|escape:'htmlall'}" />
				</div>
				<br />
				<label>{l s='Banner:' mod='mercadopagobr'}</label>
				<div class="">
					<input type="text" size="33" name="MERCADOPAGO_CREDITCARD_BANNER" value="{$creditcard_banner|escape:'htmlall'}" />
				</div>
			</fieldset>
			{foreach from=$offline_payment_settings key=offline_payment item=value}
				<fieldset>
					<legend>
						<img src="../img/admin/contact.gif" />{l s='Settings - ' mod='mercadopagobr'}{$value.name|ucfirst} {l s=' Custom' mod='mercadopagobr'}
					</legend>
					<label>{l s='Active: ' mod='mercadopagobr'}</label>
					<div class="">
						<select name="MERCADOPAGO_{$offline_payment|upper}_ACTIVE" id="{$offline_payment}_active">
							<option value="true">{l s='Yes' mod='mercadopagobr'} </option>
							<option value="false">{l s='No' mod='mercadopagobr'} </option>
						</select>
					</div>
					<br />
					<label>{l s='Banner:' mod='mercadopagobr'}</label>
					<div class="">
						<input type="text" size="33" name="MERCADOPAGO_{$offline_payment|upper}_BANNER" value="{$value.banner|escape:'htmlall'}" />
					</div>
				</fieldset>
				<br />
			{/foreach}
		{/if}
		{if $country != ''}
			<fieldset>
				<legend>
					<img src="../img/admin/contact.gif" />{l s='Settings - MercadoPago Standard' mod='mercadopagobr'}
				</legend>
				<label>{l s='Active: ' mod='mercadopagobr'}</label>
				<div class="">
					<select name="MERCADOPAGO_STANDARD_ACTIVE" id="standard_active">
						<option value="true">{l s='Yes' mod='mercadopagobr'} </option>
						<option value="false">{l s='No' mod='mercadopagobr'} </option>
					</select>
				</div>
				<br />
				<label>{l s='Banner:' mod='mercadopagobr'}</label>
				<div class="">
					<input type="text" size="33" name="MERCADOPAGO_STANDARD_BANNER" value="{$standard_banner|escape:'htmlall'}" />
				</div>
				<br />
				<label>{l s='Checkout window:' mod='mercadopagobr'}</label>
				<div class="">
					<select name="MERCADOPAGO_WINDOW_TYPE" id="window_type">
						<option value="iframe">{l s='iFrame' mod='mercadopagobr'} </option>
						<option value="redirect">{l s='Redirect' mod='mercadopagobr'} </option>
					</select>
				</div>
				<br />
				<label>{l s='Exclude payment methods:' mod='mercadopagobr'}</label>
				<div class="payment-methods">
				<br />
				{foreach from=$payment_methods item=payment_method}
					<br />
					<input type="checkbox" name="MERCADOPAGO_{$payment_method.id|upper}" id="{$payment_method.id}">{$payment_method.name}</input>
				{/foreach}
				</div>
				<label>{l s='iFrame width:' mod='mercadopagobr'}</label>
				<div class="">
					<input type="text" size="33" name="MERCADOPAGO_IFRAME_WIDTH" value="{$iframe_width|escape:'htmlall'}" />
				</div>
				<br />
				<label>{l s='iFrame height:' mod='mercadopagobr'}</label>
				<div class="">
					<input type="text" size="33" name="MERCADOPAGO_IFRAME_HEIGHT" value="{$iframe_height|escape:'htmlall'}" />
				</div>
				<br />
				<label>{l s='Max installments:' mod='mercadopagobr'}</label>
				<div class="">
					<input type="text" size="33" name="MERCADOPAGO_INSTALLMENTS" value="{$installments|escape:'htmlall'}" />
				</div>
				<br />
				<label>{l s='Auto Return: ' mod='mercadopagobr'}</label>
				<div class="">
					<select name="MERCADOPAGO_AUTO_RETURN" id="auto_return">
						<option value="approved">{l s='Yes' mod='mercadopagobr'} </option>
						<option value="false">{l s='No' mod='mercadopagobr'} </option>
					</select>
				</div>
			</fieldset>
				
			<fieldset>
				<legend class="ch-form-row discount-link" style="padding-left: 30px;">
					{l s='Coupon MercadoPago' mod='mercadopagobr'}
				</legend>
				<!-- <label class="ch-form-row discount-link">{l s='Enable discount coupon: ' mod='mercadopagobr'}</label> -->
				<label>{l s='Enable Coupon of Discount: ' mod='mercadopagobr'}</label>
				<div class="">
					<select name="MERCADOPAGO_COUPON_ACTIVE" id="coupon_active">
						<option value="true">{l s='Yes' mod='mercadopagobr'} </option>
						<option value="false">{l s='No' mod='mercadopagobr'} </option>
					</select>
				</div>
				<!--  <label>{l s='Active for Ticket: ' mod='mercadopagobr'}</label>
				<div class="">
					<select name="MERCADOPAGO_COUPON_TICKET_ACTIVE" id="coupon_ticket_active">
						<option value="true">{l s='Yes' mod='mercadopagobr'} </option>
						<option value="false">{l s='No' mod='mercadopagobr'} </option>
					</select>
				</div>-->				
			</fieldset>	
						
			<fieldset>
				<legend>
					<img src="../img/admin/contact.gif" />{l s='Settings - Active log' mod='mercadopagobr'}
				</legend>
				<label>{l s='Active: ' mod='mercadopagobr'}</label>
				<div class="">
					<select name="MERCADOPAGO_LOG" id="log_active">
						<option value="true">{l s='Yes' mod='mercadopagobr'} </option>
						<option value="false">{l s='No' mod='mercadopagobr'} </option>
					</select>
				</div>
			</fieldset>			
		{/if}
		{if empty($country)}
			<input type="submit" name="login" value="{l s='Login' mod='mercadopagobr'}" class="ch-btn ch-btn-big"/>
		{else}
			<input type="submit" name="submitmercadopago" value="{l s='Save' mod='mercadopagobr'}" class="ch-btn ch-btn-big"/>
		{/if}
			<!-- <input type="button" id="back" value="{l s='Back' mod='mercadopagobr'}" class="ch-btn-orange ch-btn-big-orange"/> -->
	</form>
</div>
<script type="text/javascript">
	$(document).ready(function (){
		// hide marketing when settings are updated
		if ($("#alerts").children().length > 0) {
			$(".marketing").hide();
			$("#settings").show();
			$.scrollTo(0, 0);
		}
	})
	
	window.onload = function() {
		if (document.getElementById("category")){
			document.getElementById("category").value = "{$category|escape:'javascript'}";
		}

		if (document.getElementById("creditcard_active")){
			document.getElementById("creditcard_active").value = "{$creditcard_active|escape:'javascript'}";
		}
		if (document.getElementById("coupon_active")){
			document.getElementById("coupon_active").value = "{$coupon_active|escape:'javascript'}";
		}	
		if (document.getElementById("coupon_ticket_active")){
			document.getElementById("coupon_ticket_active").value = "{$coupon_ticket_active|escape:'javascript'}";
		}			
		

		if (document.getElementById("standard_active")){
			document.getElementById("standard_active").value = "{$standard_active|escape:'javascript'}";
		}


		if (document.getElementById("log_active")){
			document.getElementById("log_active").value = "{$log_active|escape:'javascript'}";
		}

		if (document.getElementById("window_type")){
			document.getElementById("window_type").value = "{$window_type|escape:'javascript'}";
		}

		if (document.getElementById("auto_return")){
			document.getElementById("auto_return").value = "{$auto_return|escape:'javascript'}";
		}

		{foreach from=$payment_methods_settings key=payment_method item=value}
			document.getElementById("{$payment_method|escape:'javascript'}").checked = "{$value|escape:'javascript'}";
		{/foreach}
		
		{foreach from=$offline_payment_settings key=offline_payment item=value}
			document.getElementById("{$offline_payment}_active").value = "{$value.active|escape:'javascript'}";
		{/foreach}
	}

		$("input[type='checkbox']").click(function (e) {
			if ($("#" + e.target.id).attr("checked") !== undefined) {
				$("#" + e.target.id).val("checked");
			} else {
				$("#" + e.target.id).val("")
			}
		});
		$("#back").click(
			function() { 
				$(".marketing").show();
				$("#settings").hide();
				$("#alerts").remove();
				$.scrollTo(0, 0);
		});
	</script>

<style>
.ch-form-row.discount-link {
    background: url(https://secure.mlstatic.com/checkout-resources/resourses/assets/icon-discount.bd9c2205796f.png) no-repeat;
    line-height: 25px;
}
</style>