/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.reconocedor.automata.calculadorafront.Controllers;

import com.reconocedor.automata.calculadorafront.View.VistaCalculadora;

/**
 *
 * @author Brayan
 */
public class Main {
    public static void main (String [ ] args) {
        VistaCalculadora vista = new VistaCalculadora();
        vista.setVisible(true);
        vista.setLocationRelativeTo(null);
        
    }
}
