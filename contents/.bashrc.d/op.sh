alias op='op --cache'

opp_extract_password() { jq -r '.details | .password //(.fields[]|select(.designation=="password").value)'; }

opp() {
	local
	if json="$(op get item "$1")"; then
		echo "${json}" | opp_extract_password
	elif [[ $- == *i* ]] && [ -t 0 ]; then
		local set_token
		while ! set_token="$(op signin)"; do :; done
		eval "${set_token}" && \
			json="$(op get item "$1")" && \
			echo "${json}" | opp_extract_password
	fi
}
