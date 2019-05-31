
local Match = {}

function Match:AllOfMatcher(comList)
    local matcher = Matcher.New()
    matcher._allIndices = matcher:DistinctIndices(comList)
    return matcher
end


function Match:AnyOfMatcher(comList)
    local matcher = Matcher.New()
    matcher._anyIndices = matcher:DistinctIndices(comList)
    return matcher
end


function Match:NoneOfMatcher(comList)
    local matcher = Matcher.New()
    matcher._noneIndices = matcher:DistinctIndices(comList)
    return matcher
end

return Match