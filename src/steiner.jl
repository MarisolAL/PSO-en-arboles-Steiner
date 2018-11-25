module steiner
include("particula.jl")
include("pso.jl")
using LightGraphs, SimpleWeightedGraphs
using Random
using Dates
using DelimitedFiles

global arbol_actual

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
    puntos = Dict{Int64, Array{Float64,1}}() #Creamos un diccionario para guardar los puntos
    i = 1
    for v in S
        puntos[i] = v
        i +=1
    end
    G = SimpleWeightedGraph(long) #Hacemos una grafica con la cantidad de vertices igual a la cantidad de puntos
    for v in puntos
        for u in puntos
            if u != v
                add_edge!(G,u[1],v[1],distancia_2_puntos(u[2],v[2])) #Conectamos a todos los vertices con los demas
            end
        end
    end
    #En este punto tenemos la grafica completa
    aristas_arbol = kruskal_mst(G)
    Arbol = SimpleWeightedGraph(long)
    for v in aristas_arbol
        add_edge!(Arbol,v.src, v.dst, v.weight)
    end

    return Arbol, puntos #Regresamos el arbol y el diccionario
end


function obten_peso_total(arbol)
    suma = 0
    for v in edges(arbol[1])
       suma += v.weight
   end
   return suma
end

#Funcion que dado un arbol agrega un punto
#a la grafica y calcula el arbol
function obten_arbol_con_punto(S,p::Array{Float64,1})
    graf = copy(S[1])
    dict = copy(S[2])
    vert = nv(graf)
    dict[vert + 1] = p #a;adimos el punto al diccionario
    add_vertex!(graf) #a;adimos un vertice
    for v in vertices(graf)
        if v != vert + 1 #si no es el vertice a;adido
            add_edge!(graf,v,vert+1,distancia_2_puntos(dict[v],dict[v+1])) #Conectamos al vertice
        end
    end
    #En este punto tenemos la grafica completa
    aristas_arbol = kruskal_mst(graf)
    Arbol = SimpleWeightedGraph(vert + 1)
    for v in aristas_arbol
        add_edge!(Arbol,v.src, v.dst, v.weight)
    end
    return Arbol, dict #Regresamos el arbol y el diccionario
end

mutable struct Steiner
    puntos
    arbol
    peso::Float64
    ##La funcion recibe un conjunto de puntos
    function Steiner(S)
        puntos = Set([S])
        arbol = construye_arbol(S)
        peso = obten_peso_total(arbol)
        global arbol_actual = arbol
        new(puntos,arbol,peso)
    end
end

# Funcion que devuelve el fitness de un punto
function eval_arbol(p)
    G= obten_arbol_con_punto(arbol_actual,p)
    peso = obten_peso_total(G)
    return peso
end

function obten_puntos_steiner(st::Steiner,iteracion_maxima::Int64,swarms::Int64,tam_pob::Int64,nombre_archivo)
    k = 0
    peso_0 = st.peso
    while k < swarms
        x1 = Float64(rand(particula.limite_inferior[1]: particula.limite_superior[1]))
        x2 = Float64(rand(particula.limite_inferior[2]: particula.limite_superior[2]))
        ps = pso.PSO(eval_arbol,tam_pob,[x1,x2])
        punto_steiner = pso.corre_pso(iteracion_maxima,ps)
        punto = punto_steiner.mejor_posicion
        fit_actual = punto_steiner.fitness
        if peso_0 > punto_steiner.fitness
            porcentaje = 1 - punto_steiner.fitness/peso_0
            global arbol_actual = obten_arbol_con_punto(arbol_actual,punto)
            peso_0 = punto_steiner.mejor_fitness
            archivo = open(string(nombre_archivo,".txt"), "a")
            escritura = string(punto_steiner.mejor_fitness,"\nPORCENTAJE DE MEJORA: ",porcentaje,"\n")
            println(escritura)
            write(archivo, escritura)
            close(archivo)
        end
        k+=1
    end
end

#Pruebas
S = Set([[-2,8],[0,4],[4,8]])
S = map(x -> float(x),S)
#println(size_set(S))
arbol = construye_arbol(S)
#println(arbol[1])
#println(obten_peso_total(arbol))
arbol_2= obten_arbol_con_punto(arbol,[1.87,0])
#println(arbol_2[1])
#println(obten_peso_total(arbol_2))
stein = Steiner(S)
fecha = string("Salidas_",Dates.now())
archivo = open(string(fecha,".txt"), "a")
escritura = string("Puntos:",S,"\nPeso original\n",stein.peso,"\n")
println(escritura)
write(archivo,escritura )
close(archivo)
obten_puntos_steiner(stein, 1000,100,10,fecha)
end
