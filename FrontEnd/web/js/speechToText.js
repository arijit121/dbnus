runSpeechRecog = () => {

            let recognization = new webkitSpeechRecognition();
            recognization.onstart = () => {

            }
            recognization.onresult = (e) => {
               var transcript = e.results[0][0].transcript;

            }
            recognization.start();
         }