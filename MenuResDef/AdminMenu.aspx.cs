using System;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;
using System.IO;

namespace MenuResDef
{

    public partial class AdminMenu : System.Web.UI.Page
    {
        protected void btnAtras_Click(object sender, EventArgs e)
        {
            Response.Redirect("MenuRes.aspx");
        }

        MySqlConnection conexion = new MySqlConnection("Database=menucomida;Data Source=localhost;User=root;Port=3306");

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarProductos();
            }
        }
        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            if (fileImagen.HasFile)
            {
                if (fileImagen.PostedFile.ContentType.ToLower() == "image/png" && fileImagen.PostedFile.ContentLength <= 1024 * 1024)
                {
                    MemoryStream ms = new MemoryStream(fileImagen.FileBytes);
                    byte[] imagen = ms.ToArray();

                    InsertarProducto(txtNombre.Text, Convert.ToDecimal(txtPrecio.Text), txtDescripcion.Text, imagen);

                    LimpiarFormulario();
                    CargarProductos();

                    Literal1.Text = "Producto agregado correctamente 🟢";
                   
                }
                else
                {
                    Literal1.Text = "<script>alert('Seleccione un archivo con extensión .png y tamaño máximo de 1 MB.');</script>";
                }
            }
        }



        private void CargarProductos()
        {
            using (MySqlCommand cmd = new MySqlCommand("SELECT * FROM Producto", conexion))
            {
                conexion.Open();
                using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvProductos.DataSource = dt;
                    gvProductos.DataBind();
                }
            }
        }

        private void InsertarProducto(string nombre, decimal precio, string descripcion, byte[] imagen)
        {
            using (MySqlCommand cmd = new MySqlCommand("INSERT INTO Producto (nombre, precio, descripcion, imagen) VALUES (@nombre, @precio, @descripcion, @imagen)", conexion))
            {
                cmd.Parameters.AddWithValue("@nombre", nombre);
                cmd.Parameters.AddWithValue("@precio", precio);
                cmd.Parameters.AddWithValue("@descripcion", descripcion);
                cmd.Parameters.AddWithValue("@imagen", imagen);
                conexion.Open();
                cmd.ExecuteNonQuery();
                conexion.Close();
            }
        }

        protected void gvProductos_RowEditing(object sender, System.Web.UI.WebControls.GridViewEditEventArgs e)
        {
            gvProductos.EditIndex = e.NewEditIndex;
            CargarProductos();
        }

        protected void gvProductos_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
                int id = Convert.ToInt32(gvProductos.DataKeys[e.RowIndex].Value);

                TextBox txtNombreEdit = (TextBox)gvProductos.Rows[e.RowIndex].FindControl("txtNombreEdit");
                TextBox txtPrecioEdit = (TextBox)gvProductos.Rows[e.RowIndex].FindControl("txtPrecioEdit");
                TextBox txtDescripcionEdit = (TextBox)gvProductos.Rows[e.RowIndex].FindControl("txtDescripcionEdit");
                FileUpload fileEditarImagen = (FileUpload)gvProductos.Rows[e.RowIndex].FindControl("fileEditarImagen");
                HiddenField hfImagenActual = (HiddenField)gvProductos.Rows[e.RowIndex].FindControl("hfImagenActualEdit");

                if (txtNombreEdit != null && txtPrecioEdit != null && txtDescripcionEdit != null && fileEditarImagen != null && hfImagenActual != null)
                {
                    if (fileEditarImagen.HasFile)
                    {
                        if (fileEditarImagen.PostedFile.ContentType.ToLower() == "image/png" && fileEditarImagen.PostedFile.ContentLength <= 1024 * 1024)
                        {
                            byte[] nuevaImagen = null;

                            using (MemoryStream ms = new MemoryStream(fileEditarImagen.FileBytes))
                            {
                                nuevaImagen = ms.ToArray();
                            }

                            using (MySqlCommand cmd = new MySqlCommand("UPDATE Producto SET nombre = @nombre, precio = @precio, descripcion = @descripcion, imagen = @imagen WHERE id = @id", conexion))
                            {
                                cmd.Parameters.AddWithValue("@nombre", txtNombreEdit.Text);
                                cmd.Parameters.AddWithValue("@precio", Convert.ToDecimal(txtPrecioEdit.Text));
                                cmd.Parameters.AddWithValue("@descripcion", txtDescripcionEdit.Text);
                                cmd.Parameters.AddWithValue("@imagen", nuevaImagen);
                                cmd.Parameters.AddWithValue("@id", id);

                                conexion.Open();
                                cmd.ExecuteNonQuery();
                                conexion.Close();
                            }
                        }
                        else
                        {
                            Response.Write("<script>alert('Seleccione un archivo con extensión .png y tamaño máximo de 1 MB.');</script>");
                            return;
                        }
                    }
                    else
                    {
                        using (MySqlCommand cmd = new MySqlCommand("UPDATE Producto SET nombre = @nombre, precio = @precio, descripcion = @descripcion WHERE id = @id", conexion))
                        {
                            cmd.Parameters.AddWithValue("@nombre", txtNombreEdit.Text);
                            cmd.Parameters.AddWithValue("@precio", Convert.ToDecimal(txtPrecioEdit.Text));
                            cmd.Parameters.AddWithValue("@descripcion", txtDescripcionEdit.Text);
                            cmd.Parameters.AddWithValue("@id", id);

                            conexion.Open();
                            cmd.ExecuteNonQuery();
                            conexion.Close();
                        }
                    }

                    gvProductos.EditIndex = -1;
                    CargarProductos();  
                }
            Literal1.Text = "Producto actualizado correctamente 😊";
        }

        protected void gvProductos_RowDeleting(object sender, System.Web.UI.WebControls.GridViewDeleteEventArgs e)
        {
            if (e.RowIndex >= 0 && e.RowIndex < gvProductos.Rows.Count)
            {
                int id = Convert.ToInt32(gvProductos.DataKeys[e.RowIndex].Values["id"]);

                using (MySqlCommand cmdDeletePedidos = new MySqlCommand("DELETE FROM pedidos_productos WHERE id_producto = @id_producto", conexion))
                {
                    cmdDeletePedidos.Parameters.AddWithValue("@id_producto", id);

                    conexion.Open();
                    cmdDeletePedidos.ExecuteNonQuery();
                    conexion.Close();
                }
                using (MySqlCommand cmdDeleteProducto = new MySqlCommand("DELETE FROM Producto WHERE id = @id", conexion))
                {
                    cmdDeleteProducto.Parameters.AddWithValue("@id", id);

                    conexion.Open();
                    cmdDeleteProducto.ExecuteNonQuery();
                    conexion.Close();
                }

                CargarProductos();
            }
            Literal1.Text = "Producto borrado ❌";
        }

        protected void gvProductos_RowCancelingEdit(object sender, System.Web.UI.WebControls.GridViewCancelEditEventArgs e)
        {
            gvProductos.EditIndex = -1;
            CargarProductos();
        }

        private void LimpiarFormulario()
        {
            txtNombre.Text = "";
            txtPrecio.Text = "";
            txtDescripcion.Text = "";
            fileImagen.Dispose();
        }

    }
}