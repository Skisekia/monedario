package com.app.monedario

import androidx.compose.runtime.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavHostController
import kotlinx.coroutines.delay

/* ─── Colores que ya usas ─── */
private val LilacBackground = Color(0xFFBBA5E3)
private val GradientStart   = Color(0xFFA79BF5)   // o el mismo que tengas en RegisterScreen

@Composable
fun SplashScreen(navController: NavHostController) {

    /*  Navega después de la animación / delay  */
    LaunchedEffect(Unit) {
        delay(3400)
        navController.navigate("welcome") {
            popUpTo("splash") { inclusive = true }
        }
    }

    /*  Layout  */
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(LilacBackground),
        contentAlignment = Alignment.Center
    ) {
        Text(
            text  = "Monedario",
            style = MaterialTheme.typography.titleMedium.copy(
                fontSize = 64.sp,      // sobre-escribe tamaño
                color     = Color(0xFFFFFFFF)
            ),
        )


    }
}
