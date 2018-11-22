module steiner
include("particula.jl")
include("pso.jl")
using Graphs

"Funcion que calcula la distancia entre 2 arreglos bidimensionales"
function distancia_2_puntos(punto1::Array{Float64}, punto2::Array{Float64})
    dist = sqrt((punto1[1] - punto2[1])^2 + ((punto1[2] - punto2[2])^2))
    return dist
end

"Funcion que calcula la longitud de un conjunto"
function size_set(S)
    long = 0
    for i in S
        long +=1
    end
    return long
end

"Funcion que contruye el arbol dado el conjunto de puntos obtenidos"
function construye_arbol(S)
    S = map(x -> float(x),S) #Pasamos todos los elementos a flotantes
    long = size_set(S)
    vertices = Array{ExVertex}(long,1)
    indice = 1
    for i in S
        vertices[indice] = ExVertex(indice, string("vertice ",indice))
        vertices[indice].attributes["punto"] = i
        indice += 1
    end #En este punto tenemos la lista de los vertices
    println(vertices)
    aristas = Set([])
    for i in vertices
        for j in vertices
            if i != j
                push!(aristas, [i, j])
            end
        end
    end
    println("################")
    println(aristas)
end


function obten_peso_total(arbol)
return 0
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

S = Set([[1,0],[3,0],[0,7],[3,4],[2,7]])
S = map(x -> float(x),S)
println(size_set(S))
construye_arbol(S)
end
