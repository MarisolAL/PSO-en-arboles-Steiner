module steiner
include("particula.jl")
include("pso.jl")
using Graphs

function construye_arbol(S)

end


function obten_peso_total(arbol)

end

mutable struct Steiner
    puntos::Array{Float64,1}
    arbol
    peso::Float64
    ##La funcion recibe un conjunto de puntos
    function Steiner(S::Array{Float64,1})
        puntos = Set([S])
        arbol = construye_arbol(S)
        peso = obten_peso_total(arbol)
        new(puntos,arbol,peso)
    end
end

end
