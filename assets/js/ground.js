import {Chessground} from "chessground";

let element = document.getElementById('ground');
if(element) {
    console.log(element.dataset.fen);
    let config = {
        fen: element.dataset.fen,
        orientation: 'white'
    }
    Chessground(element, config);
}
