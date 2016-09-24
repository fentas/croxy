--[[
  References:
  - http://www.dx13.co.uk/articles/2016/5/27/selecting-a-haproxy-backend-using-lua.html

]]--
function rotator_choose_backend(txn)
--[[
  if txn.sf.req_fhdr(Host) == 'example.test.com' then
  return "backend1"
  else if txn.sf.req_fhdr(Host) == 'other.domain.com' then
  return "backend2"
  [...]
  end
  return "default_backend"
]]--
  for line in io.lines(os.getenv("ROTATOR_PROXY_FILE")) do
    if string.sub(line, 0, 1) != "#" then

    end
  end

  return "default_backend"
end

-- register hooks
core.register_fetches("rotator_choose_backend", rotator_choose_backend)
