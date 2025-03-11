import 'package:flutter/material.dart'; // Importa o Flutter para construir a interface do usuário

getAuthenticationInputDecoration({
  required Icon prefixIcon,
  required String hintText,
  required GestureDetector? suffixIcon,
}) {
  // Função para criar um InputDecoration personalizado
  return InputDecoration(
    // Cria um InputDecoration
    hintText: hintText,
    prefixIcon:
        prefixIcon, // Define o icone do InputDecoration// Define o texto de dica para o InputDecoration
    suffixIcon: suffixIcon, // Define o icone do InputDecoration
    border: const OutlineInputBorder(), // Define a borda do InputDecoration
    filled: true, // Define que o InputDecoration deve ser preenchido
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 12,
    ), // Define o padding do InputDecoration
    enabledBorder: OutlineInputBorder(
      // Define a borda do InputDecoration quando o campo está desabilitado
      borderRadius: BorderRadius.circular(12), // Define a forma da borda
      borderSide: const BorderSide(
        color: Color(0xfffc90048),
        width: 2.0,
      ), // Define a cor e largura da borda
    ),
    focusedBorder: OutlineInputBorder(
      // Define a borda do InputDecoration quando o campo está habilitado
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 248, 1, 215),
        width: 4.0,
      ),
    ),
    errorBorder: OutlineInputBorder(
      // Define a borda do InputDecoration quando houver um erro
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 2.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      // Define a borda do InputDecoration quando houver um erro
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 4.0),
    ),
  );
}
