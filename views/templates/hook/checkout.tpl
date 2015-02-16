{**
*
* NOTICE OF LICENSE
*
* This source file is subject to the Open Software License (OSL).
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/osl-3.0.php
*
* @category   	Payment Gateway
* @package    	MercadoPago
* @author      	Ricardo Brito (ricardo.brito@mercadopago.com.br)
* @copyright  	Copyright (c) MercadoPago [http://www.mercadopago.com]
* @license    	http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
*}

<link rel="stylesheet" type="text/css" href="/prestashop/modules/mercadopago/css/mercadopago.css">
{if $creditcard_active == 'true' && $public_key != ''}
<script type="text/javascript" src="https://secure.mlstatic.com/org-img/checkout/custom/1.0/checkout.js"></script>
<script type="text/javascript">
	Checkout.setPublishableKey("{$public_key|escape:'htmlall'}");
</script>
<div class="row">
	<div class="col-xs-12 col-md-6">
			<div class="mp-form"> 
				<div class="row">
					<div class="col title">
						<span class="payment-label"> {l s='CARTÃO DE CRÉDITO' mod='mercadopago'} </span>
						</br>
						<span class="poweredby"> Powered by </span>
						<img class="logo" src="{$this_path_ssl|escape:'htmlall'}modules/mercadopago/img/payment_method_logo.png">
					</div>
					{if !empty($creditcard_banner)}
					<div class="col title">
						<img src="{$creditcard_banner|escape:'htmlall'}" title="MercadoPago - Meios de pagamento" class="mp-creditcard-banner"/>
					</div>
					{/if}
				</div>
				<form action="{$this_path_ssl|escape:'htmlall'}index.php?fc=module&module=mercadopago&controller=payment" method="post" id="form-pagar-mp">
				    <div class="row">
				    	<div class="col">
					    	<label for="id-card-number">{l s='Número do cartão: ' mod='mercadopago'}</label>
					    	<input id="id-card-number" data-checkout="cardNumber" type="text" name="cardNumber"/>
					    	<div id="id-card-number-status" class="status"></div>
					    </div>
				    </div>
				   	 <div class="row">
					   	<div class="col">
					    	<label for="id-card-expiration-month">{l s='Validade: ' mod='mercadopago'}</label>
					    	<select id="id-card-expiration-month" class="small-select" data-checkout="cardExpirationMonth" type="text" name="cardExpirationMonth">
					    		<option value="01"> {l s='Janeiro' mod='mercadopago'}</option>
					    		<option value="02"> {l s='Fevereiro' mod='mercadopago'}</option>
								<option value="03"> {l s='Março' mod='mercadopago'}</option>
								<option value="04"> {l s='Abril' mod='mercadopago'}</option>
								<option value="05"> {l s='Maio' mod='mercadopago'}</option>
								<option value="06"> {l s='Junho' mod='mercadopago'}</option>
								<option value="07"> {l s='Julho' mod='mercadopago'}</option>
								<option value="08"> {l s='Agosto' mod='mercadopago'}</option>
								<option value="09"> {l s='Setembro' mod='mercadopago'}</option>
								<option value="10"> {l s='Outubro' mod='mercadopago'}</option>
								<option value="11"> {l s='Novembro' mod='mercadopago'}</option>
								<option value="12"> {l s='Dezembro' mod='mercadopago'}</option>
					    	</select>
					    </div>
					    <div class="col">
					    	<select id="id-card-expiration-year" class="small-select"  data-checkout="cardExpirationYear" type="text" name="cardExpirationYear"></select>
					    	<div id="id-card-expiration-year-status" class="status"></div>
					    </div>
					</div>
					<div class="row">
						<div class="col">
					    	<label for="id-card-holder-name">{l s='Titular do Cartão: ' mod='mercadopago'}</label>
					    	<input id="id-card-holder-name" name="cardholderName" data-checkout="cardholderName" type="text"/>
					    	<div id="id-card-holder-name-status" class="status"></div>
				    	</div>
				    </div>
					<div class="row">
				    	<div class="col">
					    	<label for="id-security-code">{l s='Código de segurança: ' mod='mercadopago'}</label>
					    	<input id="id-security-code" data-checkout="securityCode" type="text" maxlength="4"//>
					    	<img src="{$this_path_ssl|escape:'htmlall'}modules/mercadopago/img/cvv.png" class="cvv"/>
					    	<div id="id-security-code-status" class="status"></div>
					    </div> 
			    	</div>
				 	<div class="row">
				    	<div class="col">
					    	<label for="id-doc-number">{l s='CPF: ' mod='mercadopago'}</label>
					    	<input id="id-doc-number" name="docNumber" data-checkout="docNumber" type="text" maxlength="11"/>
					    	<div id="id-doc-number-status" class="status"></div>
					    </div>
				    </div>
					<div class="row">
					    <div class="col">
					    	<label for="id-installments">{l s='Parcelas: ' mod='mercadopago'}</label>
					    	<select id="id-installments" name="installments" type="text>"></select>
					    </div>
				 	</div>
				    <input name="docType"  data-checkout="docType" type="hidden" value="CPF"/>
				    <input id="amount" type="hidden" value="{$amount|escape:'htmlall'}"/>
				    <div class="row">
			    		<div class="col-bottom">
					    	<input type="submit" value="{l s='Confirmar pagamento' mod='mercadopago'}" class="ch-btn ch-btn-big" />
				    	</div>
				    </div>
				</form>
				<div class="lightbox" id="text">
				  <div class="box">
				    <div class="content">
				    	<div class="processing">
					  		<span>{l s='Processando...' mod='mercadopago'}</span>
					  	</div>
				  	</div>
				  </div>
				</div>
			</div>
		</p>
	</div>
</div>
{elseif $creditcard_active == 'true' && $public_key == ''}
<div class="bootstrap">
	<div class="alert alert-danger">
		O checkout do cartão de crédito transparente está com a public key inválida. Altere sua public key em Configurações de administrador->Módulos->Pagamentos->MercadoPago.
	</div>
</div>
{/if}
{if $boleto_active eq 'true'}
<div class="row">
	<div class="col-xs-12 col-md-6">
			<a href="javascript:void(0);" id="id-boleto">
				<div class="mp-form hover"> 
					<div class="row boleto">
						<div class="col">
							<span class="payment-label"> {l s='BOLETO' mod='mercadopago'} </span></br>
							<span class="poweredby"> Powered by </span>
							<img class="logo" src="{$this_path_ssl|escape:'htmlall'}modules/mercadopago/img/payment_method_logo.png">
						</div>
						<form action="{$this_path_ssl|escape:'htmlall'}index.php?fc=module&module=mercadopago&controller=payment" method="post" id="form-boleto-mp" style="margin-left: 30px;">
					    	<input name="payment_method_id" type="hidden" value="bolbradesco"/>
					    	<input type="submit" style="display:none;" id="id-create-boleto">
						</form>	
					</div>
				</div>
			</a>
	</div>
</div>
{/if}
{if $standard_active eq 'true'}
<div class="row">
	<div class="col-xs-12 col-md-6">
		{if $window_type eq 'iframe'}
			<div class="mp-form" style="width: {math equation="$iframe_width + 20"}px; height: {math equation="$iframe_height + 20"}px;"> 
			<iframe src="{$preferences_url|escape:'htmlall'}" name="MP-Checkout" width="{$iframe_width|escape:'htmlall'}" height="{$iframe_height|escape:'htmlall'}" frameborder="0"/>
			</div>
		{else}
			<a href="{$preferences_url|escape:'htmlall'}" id="id-standard" name="MP-Checkout" mp-mode="{$window_type|escape:'htmlall'}">
			<div class="mp-form hover"> 
				<div class="row">
					<div class="col">
					<img src="{$this_path_ssl|escape:'htmlall'}modules/mercadopago/img/payment_method_logo_120_31.png" id="id-standard-logo">
					<img src="{$standard_banner|escape:'htmlall'}" title="MercadoPago - Meios de pagamento" class="mp-standard-banner"/>
					<span class="payment-label standard"> {l s='Pague via MercadoPago e parcele em até 24 vezes' mod='mercadopago'} </span>
					</div>
				</div>
			</div>
			</a>
		{/if}
	</div>
</div>
{/if}
<script type="text/javascript">
 	$("input[data-checkout='cardNumber']").bind("keyup",function(){
      var bin = $(this).val().replace(/ /g, '').replace(/-/g, '').replace(/\./g, '');
      if (bin.length == 6){
        Checkout.getPaymentMethod(bin,setPaymentMethodInfo);
      } else if (bin.length < 6) {
			$("#id-card-number").css('background: none;');
      }
    });

    $("input[data-checkout='cardNumber']").focusout(function () {
        var card = $(this).val().replace(/ /g, '').replace(/-/g, '').replace(/\./g, '');
        var bin = card.substr(0,6);
        if (bin.length == 6) {
        	Checkout.getPaymentMethod(bin,setPaymentMethodInfo);
        } else if (bin.length < 6) {
        	$("#id-card-number").css('background: none;');
        } 
    });

    //Estabeleça a informação do meio de pagamento obtido
    function setPaymentMethodInfo(status, result){
      $.each(result, function(p, r){
          $.each(r.labels, function(pos, label){
              if (label == "recommended_method") {
                  Checkout.getInstallments(r.id ,parseFloat($("#amount").val()), setInstallmentInfo);
                  //adiciona a imagem do meio de pagamento
                  var payment_method = result[0]
                  $("#id-card-number").css(
                  			"background", "url(" + payment_method.secure_thumbnail + ") 98% 50% no-repeat")
				  $('#form-pagar-mp').append(
				  			$('<input type="hidden" name="payment_method_id"/>').val(payment_method.id));
                  return;
              }
          });
      });
    };

    //Mostre as parcelas disponíveis no div 'installmentsOption'
    function setInstallmentInfo(status, installments){
        var html_options = "";
        for(i=0; installments && i<installments.length; i++){
            html_options += "<option value='"+installments[i].installments+"'>"+installments[i].installments +" de "+installments[i].share_amount+" ("+installments[i].total_amount+")</option>";
        };
        $("#id-installments").html(html_options);
	};

	$("#form-pagar-mp").submit(function( event ) {
    	var $form = $(this);
    	var cpf = $("#id-doc-number").val();
    	
    	clearErrorStatus();

    	if (validateCpf(cpf)) {
    		Checkout.createToken($form, mpResponseHandler);
    	} else {
    		$("#id-doc-number-status").html("{l s='CPF inválido' mod='mercadopago'}");
    		$("#id-doc-number").addClass("error");
    	}
	    event.preventDefault();
	    return false;
	});

	var mpResponseHandler = function(status, response) {
		var $form = $('#form-pagar-mp');

		if (response.error) {
			$.each(response.cause, function (p, e){
				switch (e.code) {
					case "E301": 
						$("#id-card-number-status").html("{l s='Cartão inválido' mod='mercadopago'}");
						$("#id-card-number").addClass("error");
					break;
					case "E302": 
						$("#id-security-code-status").html("{l s='CVV inválido' mod='mercadopago'}");
						$("#id-security-code").addClass("error");
					break;
					case "325":
					case "326": 
						$("#id-card-expiration-year-status").html("{l s='Data inválida' mod='mercadopago'}");
						$("#id-card-expiration-month").addClass("boxshadow-error");
						$("#id-card-expiration-year").addClass("boxshadow-error");
					break;
					case "316":
					case "221": 
						$("#id-card-holder-name-status").html("{l s='Nome inválido' mod='mercadopago'}");
						$("#id-card-holder-name").addClass("error");
					break;
				}
			});
		} else {
			var card_token_id = response.id;
			$form.append($('<input type="hidden" id="card_token_id" name="card_token_id"/>').val(card_token_id));
			$form.get(0).submit();
			$(".lightbox").show();
		}
	}

	function clearErrorStatus() {
		$("#id-card-number-status").html("");
		$("#id-security-code-status").html("");
		$("#id-card-expiration-month-status").html(""); 
		$("#id-card-expiration-year-status").html("");
		$("#id-card-holder-name-status").html("");
		$("#id-doc-number-status").html("");

		$("#id-card-number").removeClass("error");
		$("#id-security-code").removeClass("error");
		$("#id-card-expiration-month").removeClass("error");
		$("#id-card-expiration-year").removeClass("error");
		$("#id-card-holder-name").removeClass("error");
		$("#id-doc-number").removeClass("error");
	}

 	function validateCpf(cpf){
        var soma;
        var resto;
        soma = 0;
        if (cpf == "00000000000")
            return false;
            
        for (i=1; i<=9; i++){
            soma = soma + parseInt(cpf.substring(i-1, i)) * (11 - i);
            resto = (soma * 10) % 11;
        }
        
        if ((resto == 10) || (resto == 11))
            resto = 0;
            
        if (resto != parseInt(cpf.substring(9, 10)) )
            return false;
            
        soma = 0;
        
        for (i = 1; i <= 10; i++){
            soma = soma + parseInt(cpf.substring(i-1, i)) * (12 - i);
            resto = (soma * 10) % 11;
        }
        
        if ((resto == 10) || (resto == 11))
            resto = 0;
        
        if (resto != parseInt(cpf.substring(10, 11))){
            return false;
        }else{
            return true;    
        }
    }

    function setExpirationYear(){
        var html_options = "";
        var currentYear = new Date().getFullYear();

        for(i=0; i <= 20; i++){
            html_options += "<option value='" + (currentYear + i).toString().substr(2,2) + "'>" + (currentYear + i) + "</option>";
        };
        $("#id-card-expiration-year").html(html_options);
  	};

  	setExpirationYear();

  	$("#id-boleto").click(function (e) {
  		$('#id-create-boleto', this).click();
  	});

  	$("#id-create-boleto").click(function (e) {
  		e.stopImmediatePropagation();
  	});

  	function createModal() {
  		$("body").append($(".lightbox"));
  	}
 	
 	createModal();

  	(function() {
  		function $MPBR_load() {
  			window.$MPBR_loaded !== true && (function() {
  			var s = document.createElement("script");
  			s.type = "text/javascript";s.async = true;
    		s.src = ("https:"==document.location.protocol?"https://www.mercadopago.com/org-img/jsapi/mptools/buttons/":"http://mp-tools.mlstatic.com/buttons/")+"render.js";
   			 var x = document.getElementsByTagName('script')[0];x.parentNode.insertBefore(s, x);window.$MPBR_loaded = true;
   			})();
   		}

    	window.$MPBR_loaded !== true ? (window.attachEvent ? window.attachEvent('onload', $MPBR_load) : window.addEventListener('load', $MPBR_load, false)) : null;
    })();
</script>