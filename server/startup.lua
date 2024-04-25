local function log(str)
  print("[ "..string.upper(str).." ]")
end

cmds = {
  ["call"] = {
    ["name"] = "call",
    ["func"] = function(id)
      rednet.send(id, "here")
    end}
}

term.clear()
term.setCursorPos(1,1)
print("EBM Security Server v1.0")
print("")
local ok, err = pcall(function() rednet.open("top") end)
if not ok then
  print("Error: Couldn't find modem!")
  sleep(3)
  os.reboot()
end

while true do 
  local id, msg = rednet.receive()
  for i, terminal in pairs(fs.list("terminals)) do
    if string.sub(msg, 1, 4) ~= "PASS" then
      log("password received!")
      for i,cmd in pairs(cmds) do
        if msg == cmd.name then
            cmd.func(id)
        end
      end
    else
      if string.sub(msg, 5, #msg) == fs.open("terminals/"..terminal, "r").readAll() then
        rednet.send(id, "correct")
      end
    end
  end
end
