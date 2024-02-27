<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminMenu.aspx.cs" Inherits="MenuResDef.AdminMenu" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Panel de administrador</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="icon" type="image/png" href="Imagenes/iconos/engranaje.png">
    <link rel="stylesheet" href="Estilos/estiloAdmin.css">

     <script>
         function soloNumeros(e) {
             var charCode = (e.which) ? e.which : e.keyCode;
             var textBoxValue = e.target.value;

             if (charCode != 46 && charCode != 44 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                 return false;
             }

             if ((charCode == 46 || charCode == 44) && (textBoxValue.match(/[,.]/g) || []).length > 0) {
                 return false;
             }

             var decimalSeparatorIndex = textBoxValue.indexOf(".") !== -1 ? textBoxValue.indexOf(".") : textBoxValue.indexOf(",");
             if (decimalSeparatorIndex !== -1) {
                 var integerPart = textBoxValue.substring(0, decimalSeparatorIndex);
                 if (integerPart.length >= 3) {
                     return false;
                 }
                 var decimalPart = textBoxValue.substring(decimalSeparatorIndex + 1);
                 if (decimalPart.length >= 2) {
                     return false;
                 }
             } else {
                 if (textBoxValue.length >= 3) {
                     return false;
                 }
             }
             return true;
         }
     </script>

</head>

<body>
    
    <form runat="server" id="formProductos" class="container">
        <div class="row justify-content-between align-items-center">
            <div class="col-md-auto">
                <asp:Button runat="server" type="button" class="btn btn-outline-primary" Text="< Cerrar" onclick="btnAtras_Click"></asp:Button>
            </div>
            <div class="col-md-6 titulo-panel-container">
                <h2 class="titulo-panel">Panel admin</h2>
            </div>
            <div class="col-md-auto"></div>
        </div>

        <asp:Literal ID="Literal1" runat="server"></asp:Literal>

        <div id="divAgregar" class="row">
            <div class="col-md-6">
                <h3>Agregar productos:</h3>
                <div class="form-group">
                    <label for="txtNombre">Nombre:</label>
                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Rellene este campo" ValidationGroup="Agregar" ControlToValidate="txtNombre" CssClass="text-danger"></asp:RequiredFieldValidator>
                </div>
                <div class="form-group">
                    <label for="txtPrecio">Precio:</label>
                    <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control" onkeypress="return soloNumeros(event)" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Rellene este campo" ValidationGroup="Agregar" ControlToValidate="txtPrecio" CssClass="text-danger"></asp:RequiredFieldValidator><br />
                    <asp:RegularExpressionValidator ID="RegexPrecio" runat="server" ControlToValidate="txtPrecio" ValidationExpression="^\d{1,3}(\,\d{1,2})?$" ErrorMessage="El formato debe ser el correcto (máximo tres enteros y dos decimales)" CssClass="text-danger" />
                </div>
                <div class="form-group">
                    <label for="txtDescripcion">Descripción:</label>
                    <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Rellene este campo" ValidationGroup="Agregar" ControlToValidate="txtDescripcion" CssClass="text-danger"></asp:RequiredFieldValidator>
                </div>
                <div class="form-group">
                    <label for="fileImagen">Imagen:</label>
                    <asp:FileUpload ID="fileImagen" runat="server" accept=".png" CssClass="form-control-file" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="Ponga una imagen" ValidationGroup="Agregar" ControlToValidate="fileImagen" CssClass="text-danger"></asp:RequiredFieldValidator>
                </div>
                <asp:Button ID="btnAgregar" runat="server" Text="Agregar Producto" OnClick="btnAgregar_Click" ValidationGroup="Agregar" CssClass="btn btn-success" />
            </div>
        </div>

        <hr />

        <div id="divActualizar" class="row">
            <div class="col-md-12">
                <h3>Productos:</h3>
                <div class="table-responsive">
                <asp:GridView ID="gvProductos" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="False" DataKeyNames="id" OnRowEditing="gvProductos_RowEditing" OnRowUpdating="gvProductos_RowUpdating" OnRowDeleting="gvProductos_RowDeleting" OnRowCancelingEdit="gvProductos_RowCancelingEdit">
                    <Columns>
                        <asp:BoundField DataField="id" HeaderText="ID" ReadOnly="True" />
                        <asp:BoundField DataField="nombre" HeaderText="Nombre" ReadOnly="True"/>
                        <asp:BoundField DataField="precio" HeaderText="Precio" ReadOnly="True" />
                        <asp:BoundField DataField="descripcion" HeaderText="Descripción" ReadOnly="True" />
                        <asp:TemplateField HeaderText="Imagen">
                            <ItemTemplate>
                                <asp:Image ID="imgProducto" runat="server" ImageUrl='<%# "data:Image/png;base64," + Convert.ToBase64String((byte[])Eval("imagen")) %>' Height="50px" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <asp:Button ID="btnEditar" runat="server" Text="Editar" CommandName="Edit" CssClass="btn btn-primary btn-sm" />
                                <asp:Button ID="btnEliminar" runat="server" Text="Eliminar" OnClientClick="return confirm('¿Está seguro de que desea eliminar este producto?');" CommandName="Delete" CssClass="btn btn-danger btn-sm" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtNombreEdit" runat="server" Text='<%# Bind("nombre") %>' CssClass="form-control" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="Rellene este campo" ValidationGroup="Actualizar" ControlToValidate="txtNombreEdit" CssClass="text-danger"></asp:RequiredFieldValidator>
                                <asp:TextBox ID="txtPrecioEdit" runat="server" Text='<%# Bind("precio") %>' CssClass="form-control" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="Rellene este campo" ValidationGroup="Actualizar" ControlToValidate="txtPrecioEdit" CssClass="text-danger"></asp:RequiredFieldValidator>
                                <asp:TextBox ID="txtDescripcionEdit" runat="server" Text='<%# Bind("descripcion") %>' CssClass="form-control" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="Rellene este campo" ValidationGroup="Actualizar" ControlToValidate="txtDescripcionEdit" CssClass="text-danger"></asp:RequiredFieldValidator>
                                <asp:FileUpload ID="fileEditarImagen" runat="server" accept=".png" CssClass="form-control-file" />
                                <asp:HiddenField ID="hfImagenActualEdit" runat="server" Value='<%# Convert.ToBase64String((byte[])Eval("imagen")) %>' />
                                <br />
                                <asp:Image ID="imgEditarImagen" runat="server" ImageUrl='<%# "data:Image/png;base64," + Convert.ToBase64String((byte[])Eval("imagen")) %>' Height="50px" />
                                <br />
                                <asp:Button ID="btnActualizar" runat="server" Text="Actualizar" CommandName="Update" ValidationGroup="Actualizar" CssClass="btn btn-success btn-sm" />
                                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CommandName="Cancel" CssClass="btn btn-secondary btn-sm" />
                            </EditItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
                </div>
        </div>
    </form>


</body>
</html>
