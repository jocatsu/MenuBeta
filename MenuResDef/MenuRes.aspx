<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MenuRes.aspx.cs" Inherits="MenuResDef.MenuRes" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="Estilos/estiloMenu.css">
    <link rel="icon" type="image/png" href="Imagenes/iconos/restaurante.png">
    
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

<script>
    $(document).ready(function () {
        var cartItems = [];
        var cartTotal = 0;

        function updateCart() {
            var cartCount = cartItems.length;
            $("#cartItemCount").text(cartCount);

            cartTotal = 0;
            for (var i = 0; i < cartItems.length; i++) {
                cartTotal += cartItems[i].price * cartItems[i].quantity;
            }
            $("#cartTotal").text(cartTotal.toFixed(2));

            var cartItemsList = $("#cartItemsList");
            cartItemsList.empty();

            for (var i = 0; i < cartItems.length; i++) {
                var item = cartItems[i];
                var row = "<tr>" +
                    "<td>" + item.name + "</td>" +
                    "<td>" + item.price.toFixed(2) + "</td>" +
                    "<td>" + item.quantity + "</td>" +
                    "<td>" +
                    "<button class='btn btn-sm btn-success btn-add' data-item-index='" + i + "'>+</button>" +
                    "<button class='btn btn-sm btn-warning btn-subtract' data-item-index='" + i + "'>-</button>" +
                    "<button class='btn btn-sm btn-danger btn-delete' data-item-index='" + i + "'>Eliminar</button>" +
                    "</td>" +
                    "</tr>";
                cartItemsList.append(row);
            }
        }

        function mostrarToast() {
            $('.toast').toast('show');
        }


        $(".addToCartBtn").on("click", function (event) {
            event.preventDefault(); 
            var productName = $(this).data("product-name");
            var productPrice = parseFloat($(this).data("product-price").replace(',', '.')).toFixed(2);

            var existingItem = cartItems.find(item => item.name === productName);

            if (existingItem) {
                existingItem.quantity++;
            } else {
                cartItems.push({
                    name: productName,
                    price: parseFloat(productPrice),
                    quantity: 1
                });
            }
            updateCart();
            mostrarToast();
            $(".btn-cart").addClass("enlarged");

            setTimeout(function () {
                $(".btn-cart").removeClass("enlarged");
            }, 1000);
        });

        $(document).on("click", ".btn-delete", function () {
            var index = $(this).data("item-index");
            cartItems.splice(index, 1);
            updateCart();
        });

        $(document).on("click", ".btn-add", function () {
            var index = $(this).data("item-index");
            cartItems[index].quantity++;
            updateCart();
        });

        $(document).on("click", ".btn-subtract", function () {
            var index = $(this).data("item-index");
            if (cartItems[index].quantity > 1) {
                cartItems[index].quantity--;
            } else {
                cartItems.splice(index, 1);
            }
            updateCart();
        });

        $("#checkoutBtn").on("click", function () {
            if (cartItems.length === 0) {
                $("#emptyCartMessage").show();
            } else {
                var url = "pago.aspx?";
                for (var i = 0; i < cartItems.length; i++) {
                    var item = cartItems[i];
                    url += "nombre" + i + "=" + encodeURIComponent(item.name) + "&";
                    url += "precio" + i + "=" + encodeURIComponent(item.price) + "&";
                    url += "cantidad" + i + "=" + encodeURIComponent(item.quantity) + "&";
                }
                window.location.href = url;
            }
        });
    });
</script>
    <title>Menú</title>
</head>
<body>


    <nav class="navbar navbar-expand-lg fixed-top">
      <div class="container d-flex justify-content-between align-items-center">
        <a class="navbar-brand" href="MenuRes.aspx"><i class="fas fa-hamburger"></i> JESV</a>
        <div class="text-center">
          <button class="btn btn-primary ml-auto btn-cart" data-toggle="modal" data-target="#cartModal">
            <i class="fas fa-shopping-cart"></i> Carrito
            <span id="cartItemCount" class="badge badge-pill">0</span>
        </button>
        </div>
        <button class="btn btn-primary ml-auto" data-toggle="modal" data-target="#loginModal">Iniciar Sesión como Admin</button>
      </div>
    </nav>
    
        <div id="imageCarousel" class="carousel slide" data-ride="carousel">
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <div class="overlay"></div>
                    <img src="Imagenes/1.jpg" class="d-block w-100" alt="Primera Imagen">
                </div>
                <div class="carousel-item">
                    <div class="overlay"></div>
                    <img src="Imagenes/2.jpg" class="d-block w-100" alt="Segunda Imagen">
                </div>
                <div class="carousel-item">
                    <div class="overlay"></div>
                    <img src="Imagenes/3.png" class="d-block w-100" alt="Tercera Imagen">
                </div>
            </div>
            <a class="carousel-control-prev" href="#imageCarousel" role="button" data-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="sr-only">Anterior</span>
            </a>
            <a class="carousel-control-next" href="#imageCarousel" role="button" data-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="sr-only">Siguiente</span>
            </a>
        </div>
       
    
    <div class="container mt-5">
     <div class="row" id="productContainer" runat="server"> </div>
  </div>

    <div class="modal fade" id="loginModal" tabindex="-1" role="dialog" aria-labelledby="loginModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="loginModalLabel">Iniciar Sesión como Admin</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                
                       <form id="loginForm" runat="server">
                           <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                           <asp:UpdatePanel ID="updatePanel" runat="server">
                <ContentTemplate>
                        <div class="form-outline form-white mb-4">
                            <asp:Label runat="server" AssociatedControlID="txtUsername" CssClass="form-label">Usuario:</asp:Label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control form-control-lg" placeholder="Ingresa tu usuario" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Rellene este campo" ValidationGroup="Iniciar" ControlToValidate="txtUsername" CssClass="text-danger"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <asp:Label runat="server" AssociatedControlID="txtPassword">Contraseña:</asp:Label>
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Ingresa tu contraseña" />
                             <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Rellene este campo" ValidationGroup="Iniciar" ControlToValidate="txtPassword" CssClass="text-danger"></asp:RequiredFieldValidator>
                        </div>
                    <asp:Label runat="server" ID="lblErrorMessage" CssClass="text-danger"></asp:Label>
                        <p>¿Quieres ser admin? Contacta con nosotros.</p>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                            <asp:Button runat="server" ID="btnIniciarSesion" Text="Iniciar sesión" ValidationGroup="Iniciar" CssClass="btn btn-primary" OnClick="Iniciar" />
                        </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </form>
                        
                </div>
            </div>
        </div>
    </div>


    <div class="modal fade" id="cartModal" tabindex="-1" role="dialog" aria-labelledby="cartModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-right" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="cartModalLabel">Resumen del Carrito</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table id="cartItemsTable" class="table">
                        <thead>
                            <tr>
                                <th>Nombre</th>
                                <th>Precio</th>
                                <th>Cantidad</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody id="cartItemsList">
                        </tbody>
                    </table>
                    <p class="text-right">Total: <span id="cartTotal">0</span>€</p>
                    <div id="emptyCartMessage" class="text-center" style="display:none;">
                          No hay artículos en tu carrito.
                    </div>
                 </div>
                <div class="modal-footer">
                    <button type="button" id="cerrar" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                    <button type="button" class="btn btn-primary" id="checkoutBtn">Pagar</button>
                </div>
            </div>
        </div>
    </div>

   <div class="toast fixed-bottom mx-auto" id="cartToast" role="alert" aria-live="assertive" aria-atomic="true" data-delay="1500">
        <div class="toast-header">
            <strong class="mr-auto">Producto añadido ☝️🛒</strong>
            <button type="button" class="ml-2 mb-1 close" data-dismiss="toast" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
        <div class="toast-body">
            Producto añadido al carrito
        </div>
    </div>


</body>
</html>