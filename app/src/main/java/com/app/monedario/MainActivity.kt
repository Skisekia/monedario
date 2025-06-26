package com.app.monedario

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.app.monedario.ui.theme.MonedarioTheme
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.NavHostController
import com.app.monedario.screens.RegisterScreen
import com.app.monedario.ui.screens.LoadingScreen

import com.app.monedario.ui.theme.GradientStart
import com.app.monedario.ui.theme.GradientEnd






class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MonedarioTheme {
                val navController = rememberNavController()
                NavHost(navController = navController, startDestination = "splash") {
                    // animación inicial
                    composable("splash") { SplashScreen(navController) }
                    // pantalla de inicio
                    composable("welcome") { WelcomeScreen(navController) }
                    // vista de registro
                    composable("register") { RegisterScreen(navController) }
                    //ainimacion de login
                    composable("loadingLogin") { LoadingScreen(navController, "login") }
                    //animacion de registro
                    composable("loadingRegister") { LoadingScreen(navController, "register") }
                }
            }
        }
    }
}
@Composable
fun WelcomeScreen(navController: NavHostController) {
    // Contenedor principal
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xF0FFFFFF)) // color fondo
            .padding(20.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {

        //texto principal
        Text(
            text = "Monedario",
            style = MaterialTheme.typography.titleMedium.copy(
                fontSize = 60.sp,

            )
        )
        // Imagen ilustrativa
        Image(
            painter = painterResource(id = R.drawable.homeicon),
            contentDescription = "Ilustración bienvenida",
            modifier = Modifier.size(400.dp)
        )
        //Spacer(modifier = Modifier.height(10.dp))

        //Loggin
        Text(
            text = buildAnnotatedString {
                append("Organiza lo que ")
                withStyle(style = SpanStyle(color = Color(0xFF673AB7), fontFamily = FontFamily.Cursive, fontSize = 40.sp)) {
                    append("tienes")
                }
            },
            style = TextStyle(fontSize = 30.sp)
        )


        Text(
            text = buildAnnotatedString {
                append("Logra lo que  ")
                withStyle(style = SpanStyle(color = Color(0xFF673AB7), fontFamily = FontFamily.Cursive, fontSize = 40.sp)) {
                    append("quieres")
                }
            },
            style = TextStyle(fontSize = 30.sp)
        )
        Spacer(modifier = Modifier.height(10.dp))
        // Botón para iniciar sesión
        Button(
            onClick = { navController.navigate("loadingLogin") },
            modifier = Modifier
                .fillMaxWidth()
                .height(50.dp),
            colors = ButtonDefaults.buttonColors(containerColor = GradientStart),
            contentPadding = PaddingValues()
        ) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(

                        Brush.horizontalGradient(listOf(GradientStart, GradientEnd)),
                        RoundedCornerShape(12.dp)
                    ),
                contentAlignment = Alignment.Center
            ) {
                Text("Iniciar sesión", color = Color.White)
            }
        }

        Spacer(Modifier.height(10.dp))

        // Botón para crear cuenta
        OutlinedButton(
            onClick = { navController.navigate("loadingRegister") }, //vista de registro

            modifier = Modifier
                .fillMaxWidth()
                .height(50.dp),

        ) {
            Text("Crear cuenta" ,
            color = Color(0xFF512DA8))

        }
    }
}

