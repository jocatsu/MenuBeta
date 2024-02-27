using System;
using System.Web.UI;
using MySql.Data.MySqlClient;

namespace MenuResDef
{
    public partial class MenuRes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarProductos();
            }
        }

        MySqlConnection conexion = new MySqlConnection("Database=menucomida;Data Source=localhost;User=root;Port=3306");

        static MySqlDataReader datareader;  

        protected void Iniciar(object sender, EventArgs e)
        {
            MySqlCommand comando1 = new MySqlCommand("SELECT * FROM admin WHERE usuario = @usuario AND contrasenia = @contrasenia", conexion);
            MySqlParameter usuario = comando1.Parameters.Add("@usuario", MySqlDbType.String);
            MySqlParameter contrasenia = comando1.Parameters.Add("@contrasenia", MySqlDbType.String);
            usuario.Value = txtUsername.Text;
            contrasenia.Value = txtPassword.Text;

            conexion.Open();
            MySqlDataReader reader = comando1.ExecuteReader();

            if (reader.HasRows)
            {
                while (reader.Read())
                {

                    Response.Redirect("AdminMenu.aspx");
                }
            }
            else {
                lblErrorMessage.Text = "Credenciales inválidas";
            }

            conexion.Close();
        }

        private void CargarProductos()
        {
            using (MySqlConnection connection = new MySqlConnection("Database=menucomida;Data Source=localhost;User=root;Port=3306"))
            {
                connection.Open();

                string query = "SELECT * FROM producto";
                MySqlCommand command = new MySqlCommand(query, connection);
                MySqlDataReader reader = command.ExecuteReader();

                while (reader.Read())
                {
                    int id = Convert.ToInt32(reader["id"]);
                    string nombre = reader["nombre"].ToString();
                    decimal precio = Convert.ToDecimal(reader["precio"]);
                    string descripcion = reader["Descripcion"].ToString();


                    byte[] imagenBytes = (byte[])reader["imagen"];
                    string imagenBase64 = Convert.ToBase64String(imagenBytes);
                    string imagenSrc = $"data:image/png;base64,{imagenBase64}";

                    LiteralControl productos = new LiteralControl();

                    string agregarAlCarritoBtn = $@"
                      <a href='#' class='btn btn-primary btn-add-to-cart addToCartBtn' 
                         data-product-name='{nombre}' data-product-price='{precio}'>
                          Agregar al carrito
                      </a>";

                                        productos.Text = $@"
                      <div class='col-md-4 mb-4 animate__animated animate__slideInLeft'>
                          <div class='card'>
                              <img src='{imagenSrc}' alt='{nombre} Image' class='card-img-top'>
                              <div class='card-body'>
                                  <h5 class='card-title'>{nombre} - {precio}€</h5>
                                  <p class='card-text'>{descripcion}</p>
                                  {agregarAlCarritoBtn}
                              </div>
                          </div>
                      </div>";


                    productContainer.Controls.Add(productos);
                }
            }
        }
    }
}
