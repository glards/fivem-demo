
exports.gl_interaction:addPortals({
    {
        Name = "Casino_interior",
        Pos = vector4(1089.88, 206.43, -50.00, 344.95),
        LinkTo = "Casino_exterior"
    },
    {
        Name = "Casino_exterior",
        Pos = vector4(935.69, 46.69, 80.10, 132.15),
        LinkTo = "Casino_interior"
    },
    {
        Name = "Casino_elevator_inside",
        Pos = vector4(1085.34, 214.57, -50.20, 307.23),
        LinkTo = "Casino_elevator_rooftop"
    },
    {
        Name = "Casino_elevator_rooftop",
        Pos = vector4(964.66, 58.74, 111.55, 70.0),
        LinkTo = "Casino_elevator_inside"
    }
})
