/* Inputs mapping */
const int bass_drum_input = A0;   
const int snare_input = A1; 
const int closed_hihat_input = A2;
const int ride_input = A3;
const int crash_input = A4;

/* MIDI channel, instrument and notes */
const int channel=10;  
const int instrument=1; // Standard set
const int bass_drum_note = 36;   
const int snare_note = 38; 
const int closed_hihat_note = 42;
const int ride_note = 51;
const int crash_note = 49;
const int velocity_threshold = 10;
const int delay_between_commands = 30;
const int higher_value_from_piezo = 900;
int bass_drum_read, snare_read, closed_hihat_read, ride_read, crash_read = 0;


void setup() {
  Serial.begin(31250); //standard midi serial baud rate
  //Serial.begin(9600);          //  debug
  delay (200);
}

void loop() {

  bass_drum_read = analogRead(bass_drum_input);
  snare_read  = analogRead(snare_input);
  closed_hihat_read = analogRead(closed_hihat_input);
  ride_read = analogRead(ride_input);
  crash_read  = analogRead(crash_input);


  bass_drum_read = map(bass_drum_read, 0, higher_value_from_piezo, 10, 60);
  snare_read = map(snare_read, 0, higher_value_from_piezo, 10, 50);
  closed_hihat_read = map(closed_hihat_read, 0, higher_value_from_piezo, 10, 127);
  ride_read = map(ride_read, 0, higher_value_from_piezo, 10, 80);
  crash_read = map(crash_read, 0, higher_value_from_piezo, 10, 60);
  
  play_note(bass_drum_note, bass_drum_read);
  play_note(snare_note, snare_read);
  play_note(closed_hihat_note, closed_hihat_read);  
  play_note(ride_note, ride_read);
  play_note(crash_note, crash_read);
  
}

void play_note(int note, int velocity) {
   if (velocity > velocity_threshold) {
      midi_com(instrument);
      delay(delay_between_commands);  
      midi_note_on(note, 127);
      delay(delay_between_commands);
      midi_note_off(note, 0);   
    } 
}

void midi_note_on(int pitch, int velocity) {
  Serial.write(0x90+channel);
  Serial.write(pitch);
  Serial.write(velocity);
}

void midi_note_off(int pitch, int velocity) {
  Serial.write(0x80+channel);
  Serial.write(pitch);
  Serial.write(velocity);
}

void midi_com(int instrument) {
  Serial.write(0xC0+channel);
  Serial.write(instrument);
}
