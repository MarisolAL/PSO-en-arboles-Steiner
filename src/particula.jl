module particula

using Random

global W = 0.5  # Constante de inercia
global C_1 = 1.25  # Constante cognitiva
global C_2 = 1.75  # Constante social
global limite_superior = [100,100]
global limite_inferior = [-100,-100]

"Estructura que modela una particula"
mutable struct Particula
    dimension::Int64 #Dimension del plano cartesiano
    fitness::Float64 #Evaluacion de la particula
    mejor_fitness::Float64 #Mejor fitness que ha alcanzado la particula
    posicion::Array{Float64,1} #Posicion actual de la particula
    mejor_posicion::Array{Float64,1} #Mejor posicion que ha tenido la particula
    empeora::Int64 #Veces que ha empeorado la evaluacion
    velocidad::Array{Float64,1} #Vector que tiene la velocidad para cada dimension
    fun_fitness::Function #Funcion que evalua el fitness
    function Particula(dimension, puntoInicial, fun_fitness)
        rng = MersenneTwister(abs(rand(Int)))
        s = 2
        #Hacemos un arreglo inicial con el tama;o de la dimension con no. aleatorios entre -1 y 1 y sumamos la posicion inicial para modificar un
        #poco donde inician las particulas
        posicion = s*rand(dimension).-s/2 + puntoInicial
        #Hacemos un arreglo con numeros aleatorios de 0 a 1 del tama;o de la dimension
        velocidad = rand!(rng, zeros(dimension))
        empeora = 0
        mejor_posicion = copy(posicion)
        fitness = fun_fitness(posicion)
        mejor_fitness = copy(fitness)
        new(dimension,fitness,mejor_fitness,posicion,mejor_posicion,empeora, velocidad,fun_fitness)
    end
end

"Funcion que actualiza la mejor posicion y fitness dados los parametros actuales"
function actualiza_mejor_individual(particula::Particula)
    #Actualizamos el valor del fitness de la nueva posicion
    evaluacion = particula.fun_fitness(particula.posicion)
    #Verificamos si el fitness ha empeorado
    if evaluacion > particula.fitness
        particula.empeora += 1
    else
        particula.empeora = 0
        #Verificamos si es mejor que el optimo encontrado
        if evaluacion < particula.mejor_fitness
            particula.mejor_posicion = particula.posicion
            particula.mejor_fitness = evaluacion
        end
    end
    particula.fitness = evaluacion
end

"Funcion que se encarga de verificar si debemos matar a una particula dado un numero maximo para empeorar,
si la mata debe de generar otra con alguna posicion"
function debo_matar(particula::Particula, empeora_max::Int64)
    if particula.empeora > empeora_max
        #Creamos una nueva particula
        p = Particula(particula.dimension, particula.posicion, particula.fun_fitness)
        particula.mejor_fitness = p.mejor_fitness
        particula.mejor_posicion = p.mejor_posicion
        particula.velocidad = p.velocidad
        particula.empeora = 0
        particula.fitness = p.fitness
        particula.posicion = p.posicion
    end
end

"Funcion que actualiza la velocidad de una particula"
function actualiza_velocidad(p::Particula, mejor_global::Particula)
    r_1 = rand()
    r_2 = rand()
    v_c = p.mejor_posicion - p.posicion #Velocidad de el mismo
    v_s = mejor_global.posicion - p.posicion #Velocidad de el mejor el sistema
    p.velocidad = (W*p.velocidad) + (C_1*r_1*v_c) + (C_2*r_2*v_s)
end

"Funcion que verifica que la particula no se salga de los limites
MODIFICAR ESTA PARA QUE SEA CASCO CONVEXO"
function verifica_posicion(p::Particula,posicion_nueva::Array{Float64,1})
    for i in 1:p.dimension
        if posicion_nueva[i]>limite_superior[i]
            posicion_nueva[i] = Float64(rand(limite_inferior[i]:limite_superior[i]))
        end
        if posicion_nueva[i]<limite_inferior[i]
            posicion_nueva[i] = Float64(rand(limite_inferior[i]:limite_superior[i]))
        end
    end
    p.posicion = posicion_nueva
end

" Funcion que actualiza la posicion dada la velocidad"
function actualiza_posicion(p::Particula)
    posicion_aux = p.posicion + p.velocidad
    #Verificamos que no nos salgamos de los limites
    verifica_posicion(p,posicion_aux)
end

end
