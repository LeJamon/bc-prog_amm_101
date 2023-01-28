const Token = artifacts.require("Token");
const ExerxiceSolution = artifacts.require("ExerciceSolution"); 

module.exports = function (deployer) {
  deployer.then(async () =>{
  
  await deployToken();
  await deploySolution();
  await deployRecap(); 
}); 

};

async function deployToken() {
  token = await Token.new()
}

async function deploySolution() {
  solution = await ExerxiceSolution.new()
}

async function deployRecap(){
  console.log("Token " + token.address); 
  console.log("Solution" +solution.address); 
}