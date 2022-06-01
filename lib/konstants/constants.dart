
enum GameType {
  battlegound,
  freefire,
  cod,
  myEvent,
}

String getGameName(GameType gType){
  if(gType == GameType.battlegound) return "battleground";
  if(gType == GameType.freefire) return "freefire";
  return "cod";
}

enum UserType{
  admin,
  manager,
  user,
}

UserType getUserType(String type){
  if(type == "admin") return UserType.admin;
  if(type == "manager") return UserType.manager;
  return UserType.user;
}