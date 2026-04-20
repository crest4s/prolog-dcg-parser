/*=============================================================================
 * main.pl — Punto de entrada del sistema
 * Práctica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
 * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
 *=============================================================================*/

:- module(main, [analizar/1, analizar_arbol/2, detectar/1]).

:- use_module(sintactico).
:- use_module(semantico).
:- use_module(deteccion).
:- use_module(mejoras).
:- use_module(conjunto_oraciones).
:- use_module(draw).
