mainCss <- "html, body, #map, .panel {margin:0; padding: 0; width: 100%; height: 100%; z-index: 9999;}
            div.outer {
              position: fixed; 
              top: 5%; 
              left: 0;
              right: 0;
              bottom: 0;
              overflow: hidden;
              padding: 0; 
            }

            .panel {display: block; max-width: 450px; opacity: 0.78; background-color: white; border: 4px solid #D7DBDD; border-radius: 12px;}
            .panel:hover{opacity: 0.95; background-color: white; transition-delay: 0;}
            .selectize-input {width: 70%; left: 15%; position: relative;}
            .control-label {left: 30%; position: relative; }
"
