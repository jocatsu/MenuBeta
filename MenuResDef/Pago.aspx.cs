using System;
using System.Collections.Generic;
using System.Data;
using System.Xml;
using HtmlAgilityPack;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;

namespace MenuResDef
{
    public partial class pago : System.Web.UI.Page
    {
        protected void btnAtras_Click(object sender, EventArgs e)
        {
            Response.Redirect("MenuRes.aspx");
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            int itemCount = (Request.QueryString.Count - 1) / 3;

            string html = "<table class='cart-table'>";
            html += "<thead><tr><th>Nombre</th><th>Precio</th><th>Cantidad</th><th>Subtotal</th></tr></thead>";
            html += "<tbody>";

            decimal totalCompra = 0;

            for (int i = 0; i < itemCount; i++)
            {
                string nombre = Request.QueryString.Get("nombre" + i);
                decimal precio = Convert.ToDecimal(Request.QueryString.Get("precio" + i), System.Globalization.CultureInfo.InvariantCulture);
                int cantidad = Convert.ToInt32(Request.QueryString.Get("cantidad" + i));

                decimal subtotal = precio * cantidad;
                totalCompra += subtotal;

                html += "<tr>";
                html += "<td>" + nombre + "</td>";
                html += "<td>" + precio.ToString("0.00") + "€</td>";
                html += "<td>" + cantidad + "</td>";
                html += "<td>" + subtotal.ToString("0.00") + "€</td>";
                html += "</tr>";
            }

            html += "</tbody>";
            html += "</table>";
            html += "<div class='total-container'>";
            html += "<p>Total de la compra: <span class='total'>" + totalCompra.ToString("0.00") + "€</span></p>";
            html += "</div>";

            litResultado.Text = html;
        }

        private int itemCount;
        private int ObtenerIdProducto(string nombreProducto)
        {
            int idProducto = -1;
            string query = "SELECT id FROM Producto WHERE nombre = @nombre";
            using (MySqlConnection connection = new MySqlConnection("Database=menucomida;Data Source=localhost;User=root;Port=3306"))
            {
                using (MySqlCommand command = new MySqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@nombre", nombreProducto);
                    connection.Open();
                    idProducto = Convert.ToInt32(command.ExecuteScalar());
                }
            }
            return idProducto;
        }
        protected void payButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid && validateForm())
            {
                string html = litResultado.Text;
                HtmlDocument doc = new HtmlDocument();
                doc.LoadHtml(html);
                HtmlNode totalNode = doc.DocumentNode.SelectSingleNode("//span[@class='total']");
                decimal totalCompra = 0;
                if (totalNode != null && decimal.TryParse(totalNode.InnerText.Replace("€", "").Trim(), out totalCompra))
                {
                    string connectionString = "Database=menucomida;Data Source=localhost;User=root;Port=3306";
                    using (MySqlConnection connection = new MySqlConnection(connectionString))
                    {
                        connection.Open();
                        string insertPedidoQuery = "INSERT INTO Pedido (fecha, total) VALUES (@fecha, @total); SELECT LAST_INSERT_ID();";
                        using (MySqlCommand command = new MySqlCommand(insertPedidoQuery, connection))
                        {
                            command.Parameters.AddWithValue("@fecha", DateTime.Now);
                            command.Parameters.AddWithValue("@total", totalCompra);
                            int pedidoId = Convert.ToInt32(command.ExecuteScalar());

                            int itemCount = (Request.QueryString.Count - 1) / 3;
                            for (int i = 0; i < itemCount; i++)
                            {
                                string nombre = Request.QueryString.Get("nombre" + i);
                                int cantidad = Convert.ToInt32(Request.QueryString.Get("cantidad" + i));
                                int productoId = ObtenerIdProducto(nombre);
                                if (productoId != -1)
                                {                   
                                    string insertProductoQuery = "INSERT INTO pedidos_productos (id_pedido, id_producto, cantidad) VALUES (@id_pedido, @id_producto, @cantidad);";
                                    using (MySqlCommand productoCommand = new MySqlCommand(insertProductoQuery, connection))
                                    {
                                        productoCommand.Parameters.AddWithValue("@id_pedido", pedidoId);
                                        productoCommand.Parameters.AddWithValue("@id_producto", productoId);
                                        productoCommand.Parameters.AddWithValue("@cantidad", cantidad);
                                        productoCommand.ExecuteNonQuery();
                                    }
                                }
                            }
                        }
                    }
                    Literal1.Text = "Pago procesado correctamente, espere su pedido 😊";
                    ClientScript.RegisterStartupScript(this.GetType(), "redirect", "setTimeout(function(){ window.location.href = 'MenuRes.aspx'; }, 3500);", true);
                }
                else
                {
                    Literal1.Text = "No se pudo obtener el total de la compra. Por favor, inténtelo de nuevo.";
                }
            }
        }


        protected bool validateForm()
        {
            string cardNumber = this.cardNumber.Text;
            string expiryDate = this.expiryDate.Text;
            string cvv = this.cvv.Text;

            if (cardNumber.Length != 16)
            {
                Literal1.Text = "El número de tarjeta debe tener 16 dígitos";
                return false;
            }

            int currentMonth = DateTime.Now.Month;
            int currentYear = DateTime.Now.Year % 100;

            string[] inputParts = expiryDate.Split('/');
            int inputMonth, inputYear;

            if (inputParts.Length != 2 || !int.TryParse(inputParts[0], out inputMonth) || !int.TryParse(inputParts[1], out inputYear))
            {
                Literal1.Text = "Formato de fecha de caducidad inválido. Debe ser algo así: MM/YY";
                return false;
            }

            if (inputMonth < 1 || inputMonth > 12)
            {
                Literal1.Text = "El mes de caducidad debe estar entre 01 y 12";
                return false;
            }

            if (inputYear < currentYear || (inputYear == currentYear && inputMonth <= currentMonth))
            {
                Literal1.Text = "La fecha de caducidad no puede ser del mismo mes o anterior al actual";
                return false;
            }

            if (cvv.Length != 3)
            {
                Literal1.Text = "El CVV debe tener 3 dígitos";
                return false;
            }

            return true;
        }


    }
}
