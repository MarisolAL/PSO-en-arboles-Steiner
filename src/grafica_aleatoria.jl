using Random

"Funcion que calcula la distancia entre 2 arreglos bidimensionales"
function distancia_2_puntos(punto1, punto2)
    dist = sqrt((punto1[1] - punto2[1])^2 + ((punto1[2] - punto2[2])^2))
    return dist
end

distancia_minima = 10

function genera_grafica(numero_puntos::Int64)
    puntos = Dict{Int64, Array{Int64,1}}()
    punto = [rand(-100:100),rand(-100:100)]
    puntos[1] = punto
    for i in 2:numero_puntos
        punto = [rand(-100:100),rand(-100:100)]
        correcto = false
        while !correcto
            for j in 1:i-1
                if distancia_2_puntos(puntos[j],punto)<distancia_minima
                    #Generamos otro punto
                    punto = [rand(-100:100),rand(-100:100)]
                else
                    correcto = true
                end
            end
        end
        puntos[i] = punto
    end
    for i in 1:numero_puntos
        println(puntos[i][1]," ",puntos[i][2])
    end
end

genera_grafica(parse(Int64,string(Meta.parse(ARGS[1]))))
