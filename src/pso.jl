module pso
include("particula.jl")

global estancamiento_max = 150000
global empeora_max = 150000

" Constructor de la clase PSO
 Fitness es la funcion de costo, tam_poblacion el tama;o del enjambre,
 iteracion maxima el numero maximo de iteraciones y x0 la semilla o base del enjambre."
mutable struct PSO
    poblacion::Array{particula.Particula,1}
    fun_fitness::Function
    mejor_global::particula.Particula
    function PSO(fun_fitness::Function, tam_poblacion::Int64, x_0::Array{Float64,1})
        dimension = size(x_0)[1]
        poblacion = Array{particula.Particula,1}(tam_poblacion)
        for i in 1:tam_poblacion
            poblacion[i] = particula.Particula(dimension, x_0, fun_fitness)
        end
        new(poblacion,fun_fitness,poblacion[1])
    end
end

"Funcion que ejecuta el algoritmo"
function corre_pso(iteracion_maxima::Int64, pso::PSO)
    i = 0 #Contador de la iteracion
    estancado = 0 #Contador de las veces que el algoritmo no mejora la evaluacion global
    while i < iteracion_maxima && estancado < estancamiento_max
        mejor_actual = pso.mejor_global.mejor_fitness
        for k in 1:size(pso.poblacion)[1]
            #Actualizamos los mejores fitness y posiciones de cada particula
            particula.actualiza_mejor_individual(pso.poblacion[k])
            if pso.poblacion[k].fitness < pso.mejor_global.fitness
                pso.mejor_global = pso.poblacion[k]
                estancado = 0
            end
        end
        poblacion_vieja = PSO(pso.fun_fitness, size(pso.poblacion)[1], pso.poblacion[1].posicion)
        #Una vez que se acaba de actualizar el mejor_global
        for k in 1:size(pso.poblacion)[1]
            poblacion_vieja.poblacion[k] = particula.debo_matar(pso.poblacion[k], empeora_max)
            poblacion_vieja.poblacion[k] = particula.actualiza_velocidad(pso.poblacion[k], pso.mejor_global)
            poblacion_vieja.poblacion[k] = particula.actualiza_posicion(pso.poblacion[k])
        end
        pso.poblacion = poblacion_vieja.poblacion
        #Si no hubo mejora
        if mejor_actual == pso.mejor_global
            estancado += 1
        end
        i += 1
    end
    #println(pso.mejor_global)
    return pso.mejor_global
end

end
