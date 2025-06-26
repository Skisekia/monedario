package com.app.monedario.screens

import androidx.annotation.RawRes
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Email
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Person
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavHostController
import com.airbnb.lottie.compose.*
import com.app.monedario.R
import com.app.monedario.R.raw.cat_typing
import com.app.monedario.ui.theme.*

/* ───── Lottie helper ───── */
@Composable
fun CatTypingLottie(
    modifier: Modifier = Modifier,
    @RawRes resId: Int = cat_typing
) {
    val composition by rememberLottieComposition(LottieCompositionSpec.RawRes(resId))
    val progress by animateLottieCompositionAsState(
        composition = composition,
        iterations  = LottieConstants.IterateForever
    )
    LottieAnimation(composition, progress, modifier)
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RegisterScreen(nav: NavHostController) {
    var name     by remember { mutableStateOf("") }
    var email    by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }

    // Gris oscuro para texto sin foco y para íconos
    val DarkGray = Color(0xFF555555)

    val txtColors = OutlinedTextFieldDefaults.colors(
        focusedTextColor            = Color.Black,
        unfocusedTextColor          = DarkGray,
        disabledTextColor           = DarkGray.copy(alpha = 0.6f),
        errorTextColor              = Color.Red,
        focusedContainerColor       = Color.Transparent,
        unfocusedContainerColor     = Color.Transparent,
        disabledContainerColor      = Color.Transparent,
        errorContainerColor         = Color.Transparent,
        cursorColor                 = GradientStart,
        selectionColors             = null,
        focusedBorderColor          = GradientStart,
        unfocusedBorderColor        = OutlineDisabled,
        disabledBorderColor         = OutlineDisabled,
        errorBorderColor            = Color.Red,
        focusedLabelColor           = GradientStart,
        unfocusedLabelColor         = DarkGray,
        disabledLabelColor          = DarkGray.copy(alpha = 0.6f),
        errorLabelColor             = Color.Red,
        focusedLeadingIconColor     = GradientStart,
        unfocusedLeadingIconColor   = DarkGray,
        disabledLeadingIconColor    = DarkGray.copy(alpha = 0.6f),
        errorLeadingIconColor       = Color.Red,
        focusedTrailingIconColor    = GradientStart,
        unfocusedTrailingIconColor  = DarkGray,
        disabledTrailingIconColor   = DarkGray.copy(alpha = 0.6f),
        errorTrailingIconColor      = Color.Red,
        focusedPlaceholderColor     = DarkGray,
        unfocusedPlaceholderColor   = DarkGray,
        disabledPlaceholderColor    = DarkGray.copy(alpha = 0.6f),
        errorPlaceholderColor       = Color.Red,
        focusedSupportingTextColor  = DarkGray,
        unfocusedSupportingTextColor= DarkGray,
        disabledSupportingTextColor = DarkGray.copy(alpha = 0.6f),
        errorSupportingTextColor    = Color.Red,
        focusedPrefixColor          = GradientStart,
        unfocusedPrefixColor        = DarkGray,
        disabledPrefixColor         = DarkGray.copy(alpha = 0.6f),
        errorPrefixColor            = Color.Red,
        focusedSuffixColor          = GradientStart,
        unfocusedSuffixColor        = DarkGray,
        disabledSuffixColor         = DarkGray.copy(alpha = 0.6f),
        errorSuffixColor            = Color.Red
    )


    Box(Modifier.fillMaxSize().background(LilacBackground)) {
        // Cabecera lila con curva inferior
        Box(
            Modifier
                .fillMaxWidth()
                .height(300.dp)
                .background(LilacBackground)
        ) {
            CatTypingLottie(
                modifier = Modifier
                    .size(300.dp)
                    .align(Alignment.TopEnd)
                    .padding(top = 12.dp, end = 16.dp)
            )
        }
        Text(
            "Monedario",
            style = MaterialTheme.typography.titleMedium.copy(fontSize = 22.sp),
            color = CardTop,
            modifier = Modifier
                .align(Alignment.TopStart)
                .padding(start = 24.dp, top = 50.dp)
        )

        // Card blanco redondeado hacia abajo
        Card(
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 250.dp)   // baja un poco para quedar debajo del gatito
                .padding(horizontal = 24.dp),
            shape = RoundedCornerShape(bottomStart = 20.dp, bottomEnd = 20.dp, topStart = 8.dp, topEnd = 8.dp),
            colors = CardDefaults.cardColors(containerColor = Color.White),
            elevation = CardDefaults.cardElevation(defaultElevation = 10.dp)
        ) {
            Column(
                Modifier
                    .padding(24.dp)
                    .fillMaxWidth(),
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                Text(
                    "Crea una cuenta",
                    style = MaterialTheme.typography.headlineSmall,
                    color = Color.Black
                )

                OutlinedTextField(
                    value = name,
                    onValueChange = { name = it },
                    label = { Text("Nombre") },
                    leadingIcon = { Icon(Icons.Default.Person, null, tint = DarkGray) },
                    colors = txtColors,
                    modifier = Modifier.fillMaxWidth()
                )

                OutlinedTextField(
                    value = email,
                    onValueChange = { email = it },
                    label = { Text("Correo electrónico") },
                    leadingIcon = { Icon(Icons.Default.Email, null, tint = DarkGray) },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Email),
                    colors = txtColors,
                    modifier = Modifier.fillMaxWidth()
                )

                OutlinedTextField(
                    value = password,
                    onValueChange = { password = it },
                    label = { Text("Contraseña") },
                    leadingIcon = { Icon(Icons.Default.Lock, null, tint = DarkGray) },
                    visualTransformation = PasswordVisualTransformation(),
                    keyboardOptions = KeyboardOptions(
                        keyboardType = KeyboardType.Password,
                        imeAction     = ImeAction.Done
                    ),
                    colors = txtColors,
                    modifier = Modifier.fillMaxWidth()
                )

                Button(
                    onClick = { nav.navigate("welcome") },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(50.dp),
                    colors = ButtonDefaults.buttonColors(containerColor = Color.Transparent),
                    contentPadding = PaddingValues()
                ) {
                    Box(
                        Modifier
                            .fillMaxSize()
                            .background(
                                Brush.horizontalGradient(listOf(GradientStart, GradientEnd)),
                                RoundedCornerShape(12.dp)
                            ),
                        contentAlignment = Alignment.Center
                    ) {
                        Text("Crear cuenta", color = Color.White)
                    }
                }

                Row(verticalAlignment = Alignment.CenterVertically) {
                    Divider(
                        Modifier
                            .weight(1f)
                            .height(1.dp),
                        color = DarkGray
                    )
                    Text(
                        "  Continuar con  ",
                        style = MaterialTheme.typography.labelMedium,
                        color = DarkGray
                    )
                    Divider(
                        Modifier
                            .weight(1f)
                            .height(1.dp),
                        color = DarkGray
                    )
                }

                Row(
                    horizontalArrangement = Arrangement.spacedBy(12.dp),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    OutlinedButton(onClick = { /*TODO*/ }, Modifier.weight(1f)) {
                        Image(
                            painter = painterResource(R.drawable.icongoogle),
                            contentDescription = null,
                            modifier = Modifier.size(18.dp)
                        )
                        Spacer(Modifier.width(6.dp))
                        Text("Google", color = DarkGray)
                    }
                    OutlinedButton(onClick = { /*TODO*/ }, Modifier.weight(1f)) {
                        Image(
                            painter = painterResource(R.drawable.iconfacebook),
                            contentDescription = null,
                            modifier = Modifier.size(18.dp)
                        )
                        Spacer(Modifier.width(6.dp))
                        Text("Facebook", color = DarkGray)
                    }
                }
            }
        }
    }
}
