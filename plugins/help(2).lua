
do
 function run(msg, matches)
   if msg.to.type == 'channel' then 
   if not is_owner(msg) then
    return
    end
   return [[<b>SuperGroup Helps:👇🏻</b> 
 
<b>️!block </b>
Kicks a user from SuperGroup 
 
<b>!ban </b>
Bans user from the SuperGroup 
 
<b>!unban</b> 
Unbans user from the SuperGroup 
 
<b>!id from</b> 
Get ID of user message is forwarded from 
 
<b>️!promote [username|id]</b> 
Promote a SuperGroup moderator 
 
<b>️!demote [username|id]</b> 
Demote a SuperGroup moderator 
 
<b>[!setname|!setphoto|!setrules|!setabout]</b> 
Sets the chat name, photo, rules, about text 
 
<b>!newlink </b>
Generates a new group link 
 
<b>!link</b> 
Retireives the group link 
 
<b>️[!lock|!unlock]</b>
 [links|flood|spam|Arabic|member|rtl|sticker|contacts|strict|media|bots|fwd|reply|share|tag|number|operator|poker] 
<b>Lock group settings</b> 
 
<b>[!mute|!unmute]</b>
 [all|audio|gifs|photo|video|service] 
<b>mute group message types</b> 
 
<b>!setflood [value]</b> 
Set [value] as flood sensitivity, Max:20 and Min:5 
 
<b>️!settings</b> 
Returns chat settings 
 
<b>[!muteslist|!mutelist]</b> 
Returns mutes or mute lists for chat 
 
<b>️!muteuser [username]</b> 
Mute a user in chat 
 
<b>️!banlist</b> 
Returns SuperGroup ban list 
 
<b>!clean</b>
 [rules|about|modlist|mutelist] 
 
<b>!del</b> 
Deletes a message by reply 
 
<b>!public [yes|no]</b> 
Set chat visibility in pm !chats or !chatlist commands 
 
<b>SuperGroup Commands:</b>
 (For memebers and moderators!) 
 
<b>️!info</b> 
Displays general info about the SuperGroup 
 
<b>️!admins</b> 
Returns SuperGroup admins list 
 
<b>!owner</b> 
Returns group owner 
 
<b>️!modlist</b> 
Returns Moderators list 
 
<b>️!id </b>
Return SuperGroup ID or user id 
 
<b>️!kickme</b> 
Kicks user from SuperGroup 
 
<b>️!note text</b> 
add a note 
 
<b>!mynote</b> 
get note 
 
<b>!tosticker </b>
create sticker with a photo 
 
<b>!tophoto</b> 
create photo with a sticker 
 
<b>️!rules</b> 
Retrieves the chat rules 
 
<b>️!chats</b> 
show list of bot groups in pv]]
end
 end
return {
patterns = {
"^[/!#]([Hh]elp)$",
"^help$",
"^راهنما$",
},
run = run
}
end
