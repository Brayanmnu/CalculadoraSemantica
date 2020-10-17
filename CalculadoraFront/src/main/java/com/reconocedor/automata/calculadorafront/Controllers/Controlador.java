/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.reconocedor.automata.calculadorafront.Controllers;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Brayan
 */
public class Controlador {

    private static void ejecutarBat(String cmd) {
        try {

            String linea = "";
            Process p = Runtime.getRuntime().exec(cmd);
            try (BufferedReader input = new BufferedReader(new InputStreamReader(p.getInputStream()))) {
                while ((linea = input.readLine()) != null) {
                    System.out.println(linea);
                }
            }
        } catch (IOException e) {
            System.out.println("Error :" + e.getMessage());
        }
    }

    private static void escribirTxt(String ruta, String texto) {
        FileWriter fichero = null;
        PrintWriter pw = null;
        try {
            fichero = new FileWriter(ruta);
            pw = new PrintWriter(fichero);
            pw.println(texto);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                // Nuevamente aprovechamos el finally para 
                // asegurarnos que se cierra el fichero.
                if (null != fichero) {
                    fichero.close();
                }
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
    }

    private static List<String> leerResultados(String ruta) {
        List<String> resultado = new ArrayList<>();
        File archivo = null;
        FileReader fr = null;
        BufferedReader br = null;

        try {
            // Apertura del fichero y creacion de BufferedReader para poder
            // hacer una lectura comoda (disponer del metodo readLine()).
            archivo = new File(ruta);
            fr = new FileReader(archivo);
            br = new BufferedReader(fr);

            // Lectura del fichero
            String linea;
            while ((linea = br.readLine()) != null) {
                resultado.add(linea);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // En el finally cerramos el fichero, para asegurarnos
            // que se cierra tanto si todo va bien como si salta 
            // una excepcion.
            try {
                if (null != fr) {
                    fr.close();
                }
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
        return resultado;
    }

    public List<String> analizarOperacion(String operacion) {
        URL rutaca = Controlador.class.getProtectionDomain().getCodeSource().getLocation();
        String ruta = rutaca.toString();
        String[] rutaStr = ruta.split("/");
        String rutaFinal = "";
        int i = 0;
        for (String str : rutaStr) {
            if (i > 0 && i < rutaStr.length - 2) {
                rutaFinal += str + "\\";
            }
            i++;
        }
        
        rutaFinal += "src\\main\\java\\com\\reconocedor\\automata\\calculadorafront\\";
        escribirTxt(rutaFinal + "Controllers\\Comando.bat",
                "cd "+rutaFinal+"AnalizadorSemantico\nProyecto1.exe");
        escribirTxt(rutaFinal + "AnalizadorSemantico\\codigo.txt", operacion);
        ejecutarBat(rutaFinal + "Controllers\\Comando.bat");
        return leerResultados(rutaFinal + "AnalizadorSemantico\\resultados.txt");
    }

}
