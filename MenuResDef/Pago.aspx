<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pago.aspx.cs" Inherits="MenuResDef.pago" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Pago</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" />
    <link rel="stylesheet" href="Estilos/estiloPago.css" />
    <link rel="icon" type="image/png" href="Imagenes/iconos/signo-de-dolar.png" />

    <script>
        function soloNumeros(e) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
    </script>

</head>
<body>
    <form id="pagoFormulario" runat="server">
        
   <div class="container">
    <div class="row align-items-center">
        <div class="col-md-auto">
            <asp:Button runat="server" type="button" class="btn btn-outline-primary" Text="< Volver a MENU" onclick="btnAtras_Click"></asp:Button>
        </div>
        <div class="col-md-auto titulo-panel-container">
            <h2 class="titulo-panel text-center">Resumen de compra</h2>
        </div>
    </div>
    <div>
        <asp:Literal ID="litResultado" runat="server"></asp:Literal>
    </div>
</div>

    <div class="container payment-form">
        
            <h2 class="payment-form-title"><i class="far fa-credit-card card-type-icon"></i>Pago 💳</h2>

            <div class="form-group">
                <label for="cardNumber">Número de Tarjeta:</label>
                <asp:TextBox ID="cardNumber" runat="server" placeholder="Ingrese el número de tarjeta" CssClass="form-control" MaxLength="16" onkeypress="return soloNumeros(event)" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ValidationGroup="Pagar" ErrorMessage="Rellene este campo" ControlToValidate="cardNumber" CssClass="text-danger"></asp:RequiredFieldValidator>
            </div>
            <div class="form-group">
                <label for="expiryDate">Fecha de Caducidad (MM/YY):</label>
                <asp:TextBox ID="expiryDate" runat="server" placeholder="MM/YY" CssClass="form-control" MaxLength="5" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ValidationGroup="Pagar" ErrorMessage="Rellene este campo de forma correcta" ControlToValidate="expiryDate" CssClass="text-danger"></asp:RequiredFieldValidator>
            </div>
            <div class="form-group">
                <label for="cvv">CVV:</label>
              <asp:TextBox ID="cvv" runat="server" placeholder="Ingrese el CVV" CssClass="form-control" MaxLength="3" onkeypress="return soloNumeros(event)" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ValidationGroup="Pagar" ErrorMessage="Rellene este campo" ControlToValidate="cvv" CssClass="text-danger"></asp:RequiredFieldValidator>
            </div>
        
            <asp:Button runat="server" ID="payButton" Text="Pagar" CssClass="btn btn-primary" OnClick="payButton_Click" ValidationGroup="Pagar" /><br /><br />
         <asp:Literal ID="Literal1" runat="server"></asp:Literal>
        </div>
    </form>

</body>
</html>