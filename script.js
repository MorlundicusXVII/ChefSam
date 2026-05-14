let click=false;
let answer="";
async function send(){
    let url="http://127.0.0.1:8080"
    if(click){
        alert("aspetta");
        return
    }
    try {
        click = true;
        let input =document.querySelector("#message").value;
        document.querySelector("#message").value = "";
        let options ={
            method:"POST",
            body:JSON.stringify({input}),
            headers:{"Content-Type":"application/json"},
        }

        let res=await fetch(url+"/chat",options);
        let data =await res.json();
        answer =data["ai"];
    } catch (error) {
        console.log("error:"+error);
    }finally{
        click=false;
        let chat =document.querySelector("#chat");
        let ai =document.createElement("article");
        ai.textContent=answer
        chat.appendChild(ai);
    }


   
   
}