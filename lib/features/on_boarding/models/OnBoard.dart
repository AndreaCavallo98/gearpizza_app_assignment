class OnBoard {
  final String image, text1, text2;

  OnBoard({required this.image, required this.text1, required this.text2});
}

List<OnBoard> onboards = [
  OnBoard(
    image: 'assets/images/logo.png',
    text1: 'Benvenuto \nin Gear Pizza!',
    text2: 'La pizza a casa tua',
  ),
  OnBoard(
    image: 'assets/images/pizza.png',
    text1: 'Seleziona il \nRistorante!',
    text2: 'e inserisci nel carrello le pizze',
  ),
  OnBoard(
    image: 'assets/images/rider.png',
    text1: 'Ordina! \nEd ecco fatto!',
    text2: 'La tua cena sta arrivando..',
  ),
];
