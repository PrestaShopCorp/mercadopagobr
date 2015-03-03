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

{if $version eq 6}
<div class="bootstrap">
	<div class="alert alert-danger">
		Módulo MercadoPago está com client id e client secret inválidos. Altere suas credenciais em Configurações de administrador->Módulos->Pagamentos->MercadoPago.
	</div>
</div>
{elseif $version eq 5}
<div class="error">
	Módulo MercadoPago está com client id e client secret inválidos. Altere suas credenciais em Configurações de administrador->Módulos->Pagamentos->MercadoPago.
</div>
{/if}