package com.app.monedario.screens          // ← solo un package

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.*
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavHostController
import com.app.monedario.ui.theme.*          // 4 colores
import com.app.monedario.utils.GatitoEscribiendo

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RegisterScreen(navController: NavHostController) {

    /* ---- estado de los campos ---- */
    var name        by remember { mutableStateOf("") }
    var lastName    by remember { mutableStateOf("") }
    var email       by remember { mutableStateOf("") }
    var password    by remember { mutableStateOf("") }
    var gender      by remember { mutableStateOf("") }
    var expanded    by remember { mutableStateOf(false) }

    val genderOptions = listOf("Femenino", "Masculino", "Otro")

    /* ---- colores de los OutlinedTextField ---- */
    val fieldColors = OutlinedTextFieldDefaults.colors(
        focusedBorderColor      = PurplePrimary,
        unfocusedBorderColor    = SmokeViolet,
        cursorColor             = PurplePrimary,
        focusedLabelColor       = PurplePrimary,
        unfocusedLabelColor     = SmokeViolet,
        focusedContainerColor   = SoftMauve,
        unfocusedContainerColor = SoftMauve
    )

    /* ------------- UI ------------- */
    Column(
        Modifier
            .fillMaxSize()
            .padding(horizontal = 24.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.SpaceEvenly
    ) {

        /* Gatito fuera del card */
        GatitoEscribiendo()

        /* Card-contenedor del formulario */
        Card(
            modifier = Modifier.fillMaxWidth(),
            shape    = RoundedCornerShape(28.dp),
            colors   = CardDefaults.cardColors(containerColor = LavenderMist),
            elevation= CardDefaults.cardElevation(8.dp)
        ) {
            Column(
                Modifier
                    .padding(24.dp)
                    .fillMaxWidth(),
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {

                Text(
                    "Crear Cuenta",
                    style = MaterialTheme.typography.titleLarge,
                    fontWeight = FontWeight.Bold,
                    color = PurplePrimary
                )

                /* ------ campos ------ */
                OutlinedTextField(
                    value = name,
                    onValueChange = { name = it },
                    label = { Text("Nombre") },
                    shape = RoundedCornerShape(20.dp),
                    colors = fieldColors,
                    modifier = Modifier.fillMaxWidth()
                )

                OutlinedTextField(
                    value = lastName,
                    onValueChange = { lastName = it },
                    label = { Text("Apellido") },
                    shape = RoundedCornerShape(20.dp),
                    colors = fieldColors,
                    modifier = Modifier.fillMaxWidth()
                )

                OutlinedTextField(
                    value = email,
                    onValueChange = { email = it },
                    label = { Text("Correo electrónico") },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Email),
                    shape = RoundedCornerShape(20.dp),
                    colors = fieldColors,
                    modifier = Modifier.fillMaxWidth()
                )

                OutlinedTextField(
                    value = password,
                    onValueChange = { password = it },
                    label = { Text("Contraseña") },
                    visualTransformation = PasswordVisualTransformation(),
                    keyboardOptions = KeyboardOptions(
                        keyboardType = KeyboardType.Password,
                        imeAction = ImeAction.Done),
                    shape = RoundedCornerShape(20.dp),
                    colors = fieldColors,
                    modifier = Modifier.fillMaxWidth()
                )

                /* ------ dropdown género ------ */
                ExposedDropdownMenuBox(
                    expanded = expanded,
                    onExpandedChange = { expanded = !expanded }
                ) {
                    OutlinedTextField(
                        readOnly = true,
                        value = gender,
                        onValueChange = {},
                        label = { Text("Sexo") },
                        trailingIcon = {
                            ExposedDropdownMenuDefaults.TrailingIcon(expanded)
                        },
                        shape = RoundedCornerShape(20.dp),
                        colors = fieldColors,
                        modifier = Modifier
                            .menuAnchor()
                            .fillMaxWidth()
                    )
                    ExposedDropdownMenu(
                        expanded = expanded,
                        onDismissRequest = { expanded = false }
                    ) {
                        genderOptions.forEach { g ->
                            DropdownMenuItem(
                                text = { Text(g) },
                                onClick = {
                                    gender = g
                                    expanded = false
                                }
                            )
                        }
                    }
                }

                /* ------ botón ------ */
                Button(
                    onClick = { navController.navigate("welcome") },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(50.dp),
                    colors = ButtonDefaults.buttonColors(containerColor = PurplePrimary)
                ) {
                    Text("Registrarse", color = Color.White)
                }
            }
        }
    }
}
