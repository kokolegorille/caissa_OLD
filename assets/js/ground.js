import {Chessground} from "chessground";

try {
    let element = document.getElementById('ground');
    console.log(element.dataset.fen);
    let config = {
        fen: element.dataset.fen,
        orientation: 'white'
    }
    let ground = Chessground(element, config);
}
catch(err) {
    console.log(`Opps, there was an error ${err}`)
}
