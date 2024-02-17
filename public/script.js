docReady(function() { 

  var audio = new Audio('../clickbones.wav');
  let berni = new Image();
  berni.src = '/ape.jpg';
  berni.onload = () => {
    const sound = new headbreaker.Canvas('sound-canvas', {
      width: 512, height: 512,
      pieceSize: 100, proximity: 20,
      borderFill: 10, strokeWidth: 1.5,
      lineSoftness: 0.18, image: berni,
      strokeColor: 'black'
    });

    sound.adjustImagesToPuzzleHeight();
    sound.autogenerate({
      horizontalPiecesCount: 8,
      verticalPiecesCount: 8,
      insertsGenerator: headbreaker.generators.random
    });
    sound.draw();  

    sound.onConnect((_piece, figure, _target, targetFigure) => {
      figure.shape.stroke('yellow');
      targetFigure.shape.stroke('yellow');
      audio.play();
      sound.redraw();
      setTimeout(() => {
        figure.shape.stroke('black');
        targetFigure.shape.stroke('black');
        sound.redraw();
      }, 100);
    });
  
    sound.onDisconnect((it) => {
      audio.play();
    });
  
    registerButtons('sound', sound);
  }
});

function docReady(fn) {
    // see if DOM is already available
    if (document.readyState === "complete" || document.readyState === "interactive") {
        // call on next available tick
        setTimeout(fn, 1);
    } else {
        document.addEventListener("DOMContentLoaded", fn);
    }
}   

