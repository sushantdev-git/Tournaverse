import 'package:e_game/konstants/ThemeConstants.dart';
import 'package:flutter/material.dart';
import 'package:e_game/widgets/TextAndIcon.dart';

class GameRules extends StatelessWidget {
  const GameRules({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("""
Rules
👉 PRIZEPOOL
Prize money will be transferred to the registered payment/Google pay number in 24 hours from the end of the tournament.

👉 RANKING
Player/Team Ranking will be decided using our point table system

👉 SCHEDULE
Schedule is subject to changes and is flexible management can alter and reschedule if required so keep yourself updated through match update tab.

👉 REFUND
Once you have registered in the event , the money will not be refunded.If the management fails to conduct the event then the registration fee will be refunded to the registered payment /Google pay number.

👉 GAME VERSION
All players must install the latest version of the game in order to participate in tournament. Update must be installed before the match starts.

👉 TECHNICAL ISSUES
Teams are responsible for their own technical issues (hardware/internet). Matches will not be rescheduled because of technical issues and matches will be played nevertheless.

👉  DISQUALIFICATION
To keep tournament as efficient as possible management reserves the right to disqualify teams.

Management will Request for POV Recording of any player,at any point of time. If not provided, Management reserves the rights on taking decision for any suspicious activities.

Usage of Game Guardian,GFX TOOLS and/or other 3rd party apps that enhance, add, modify, or remove game appearance , colour ,or files, is strictly prohibited during tournament. The intentional use of any bugs, glitches, or errors in the game is strictly forbidden and will lead to  disqualification of the team/player.

Any team found to be using known exploits will be removed from the tournament and barred from all future ones as well. No emulator player will be allowed , if emulator player found on lobby then whole team will be disqualified. Any type of Hacking or teaming up will result in disqualification.

👉 MISCELLANEOUS
Every team will be assigned a slot, and while in the room must join the squad

Corresponding to his/ her slot number. Repeatedly joining other teams,will result in disqualification of the individual from the tournament.

Only registered team members are allowed to play for a team, playing with unregistered player will lead your team to disqualification.

If you've a doubt someone is hacking / cheating record your POV and send it to Management.

All players participating in the tournament must submit their in- game ID while registering and it will checked.

The game ID is needed to invite players into a custom match and to check if the registered player is playing. Teams/players must enter rooms 5 minutes before the starting Timing.

Teams must take screenshot of results maybe asked by the management any time.if any team found leaking IDP it will lead to ban from the tournament.

Abusing on ALL MIC/ALL CHAT is strictly prohibited,if found abusing team will be disqualified.

There won't be any re-matches, expect the management decides to.

Management won't be responsible if you miss any of your match for any reason.

Rematch won't be done if you miss any match.


ALL ABOVE RULES CAN CHANGE WITHOUT PRIOR NOTICE.""", style: whiteTextTheme,)
        ]);
  }
}
