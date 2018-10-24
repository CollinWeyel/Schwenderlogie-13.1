;-------------------------------------------------------------------------------
; Ansteuerung eines Inkrementalgebers
; von Collin Weyel & Noah Graetz
;
; Beschreibung:
; Wird am angeschalteten Inkrementalgeber gedreht, setzt sich ein Lauflicht,
; bestehend aus drei, der auf dem Board verbauten LEDs in "Bewegeung".
; Das Drehen führt je nach Drehrichtung in eine andere Richtung:
; a) GRUEN -> ROT -> GELB -> GRUEN -> ...
; b) GRUEN -> GELB -> ROT -> GRUEN -> ...
;
; Anschaltung:
; Eingaenge:    PORTD2 -> Datenausgang A
;               PORTD3 -> Datenausgang B
; Ausgaenge:    PORTB0 -> rote LED
;               PORTB1 -> gelbe LED
;               PORTB2 -> gruene LED
;-------------------------------------------------------------------------------

.INCLUDE "m8def.inc"
.CSEG
.ORG    0x0000

RESET:
  RJMP  INIT

.ORG    INT_VECTORS_SIZE

INIT:
  LDI   R16, HIGH(RAMEND)
  OUT   SPH, R16
  LDI   R16, LOW(RAMEND)
  OUT   SPL, R16

INIT_REGISTER:
  IN    R16, DDRD         ; PORTD2 & PORTD3
  ANDI  R16, 0b11110011   ; -> INPUT
  OUT   DDRD, R16
  IN    R16, PORTD        ; PORTD2 & PORTD3
  ORI   R16, 0b00001100   ; -> PULLUP
  OUT   PORTD, R16

  IN    R16, DDRB         ; PORTB0, PORTB1 & PORTB2
  ORI   R16, 0b00000111   ; -> OUTPUT
  OUT   DDRB, R16

  IN    R16, PIND         ; Zustand von PORTD in R16 speichern
  ANDI  R16, 0b00000100   ; und A ausmaskieren

  SBI   PORTB, 2          ; Gruene LED anschalten

MAIN:
  MOV   R18, R16          ; Vorherigen Zustand von A in R18 speichern
  IN    R16, PIND         ; Zustand von PORTD in R16 speichern
  ANDI  R16, 0b00000100   ; und A ausmaskieren
  CP    R16, R18          ; Vorherigen und aktuellen Zustand von A vergleichen
  BREQ  MAIN              ; bei keiner Änderung zu MAIN springen

  IN    R18, PIND         ; Zustand von PORTD in R16 speichern,
  ANDI  R18, 0b00001000   ; B ausmaskieren und
  LSR   R18               ; auf "Höhe" von A schieben
  CP    R16, R18          ; Zustand von A und B vergleichen...(Zeile 50)

  IN    R18, PORTB        ; Zustand von PORTB (LEDs) in R18 speichern
  CBI   PORTB, 0          ; Rote LED ausschalten
  CBI   PORTB, 1          ; Gelbe LED ausschalten
  CBI   PORTB, 2          ; Gruene LED ausschalten

  BREQ  COUNTERCLOCKWISE  ; A == B -> zu COUNTERCLOCKWISE springen
                          ; A != B -> weitermachen
CLOCKWISE:
  SBRC  R18, 0            ; Wenn laut R18 die rote LED an war,
  SBI   PORTB, 1          ; die gelbe LED anschalten
  SBRC  R18, 1            ; Wenn laut R18 die gelbe LED an war,
  SBI   PORTB, 2          ; die gruene LED anschalten
  SBRC  R18, 2            ; Wenn laut R18 die gruene LED an war,
  SBI   PORTB, 0          ; die rote LED anschalten

  RJMP  MAIN              ; zurück zu MAIN springen

COUNTERCLOCKWISE:
  SBRC  R18, 0            ; Wenn laut R18 die rote LED an war,
  SBI   PORTB, 2          ; die gruene LED anschalten
  SBRC  R18, 1            ; Wenn laut R18 die gelbe LED an war,
  SBI   PORTB, 0          ; die rote LED anschalten
  SBRC  R18, 2            ; Wenn laut R18 die gruene LED an war,
  SBI   PORTB, 1          ; die gelbe LED anschalten

  RJMP  MAIN              ; zurück zu MAIN springen

.EXIT
