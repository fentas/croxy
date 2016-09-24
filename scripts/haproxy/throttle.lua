function throttle_request(txn)
  core.msleep(os.getenv("THROTTLE_MIN") + math.random(os.getenv("THROTTLE_MIN") - os.getenv("THROTTLE_MAX")))
end

-- register hooks
core.register_action("throttle_request", { "http-req" }, throttle_request);
