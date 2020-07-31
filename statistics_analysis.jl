#Importando el manipulador de paquetes
using Pkg;

##Importando los paquetes
Pkg.add("Distributions") # Crear variables "random" aleatorias
Pkg.add("StatsBase") # Soporte de estadistica básica
Pkg.add("CSV") # Escribir y leer archivos CSV
Pkg.add("DataFrames") #Crear nuestra estructura de datos
Pkg.add("HypothesisTests") # Pruebas estadísticas de rendimiento
Pkg.add("StatsPlots") #Librería para graficar
Pkg.add("GLM") #Generar modelos lineales

#Importando los paquetes
using Distributions # Crear variables "random" aleatorias
using StatsBase # Soporte de estadistica básica
using CSV #Escribir y leer archivos CSV
using DataFrames #Crear nuestra estructura de datos
using HypothesisTests # Pruebas estadísticas de rendimiento
using StatsPlots #Librería para graficar
using GLM #Generar modelos lineales

#Configurando la librería de visualización de datos
Pkg.add("PyPlot")
pyplot()

#Creación de variables aleatorias
age = rand(18:80, 100); #Distribucuón normal
wcc = round.(rand(Distributions.Normal(12, 2), 100), digits= 1) #distribución normal, redondeando a un décimal
crp = round.(Int, rand(Distributions.Chisq(4), 100)) .*10 #
treatment = rand(["A" , "B"], 100); #Pesos uniformes
result = rand(["Improved", "Static", "Worse"], 100); 

#Análisis De estadística descriptiva

#Obtener la media de la variable AGE
mean(age)

#Obtener mediana
median(age)

#Obtener desvación estandar
std(age)

#obtener la varianza
var(age)

#Estadísitca descriptiva para la variable age
StatsBase.describe(age)

# La función summarystats() omite el tipo de datos
StatsBase.summarystats(wcc)

#CREANDO UN DATAFRAME DE Pruebas

#Colocando nuestras variables generadas aleatoriamente en un dataframe
data = DataFrame(Age = age, WCC = wcc, CRP = crp, Treatment = treatment, Result = result);
#Mostrando las primeras 5 columnas de nuestros datos
first(data, 5)

#Obteniendo el numero de columnas y filas
size(data)

#Obteniendo las primeras 6 columnas
head(data)

# Podemos crear objetos de nuestros dataframes, seleccionando solo aquellos que queremos procesar o trabajar teniendo en cuenta una variable particular
dataA = data[data[!,:Treatment] .== "A", :]; #obtener los pacientes del tratamiento a
dataB = data[data[!, :Treatment] .== "B", :]#obtener los pacientes del tratamiento b
first(dataB, 5)


# Estadística descriptiva utilizando nuestro objeto -> DataFrame

#la funcion describe nos entrega información estadística de nuestro set de datos
describe(data)


#Se pueden contar los elementos en un espacio de ejemplo utilizando la función by() 
# Contando el número de pacientes in los grupos A y B
by(data, :Treatment, df -> DataFrame(N = size(df,1)))


# La función size() nos entrega la misma salida agregando el numero de variables
by(data, :Treatment, size)

# Usualmente la estádistica descriptiva de una variable numérica puede ser 
#calculada despues de separarse de las variables categóricas

#Calculando la media de la variable AGE en el DATAFRAME de los pacientes de los grupos A y B
by(data, :Treatment, df -> mean(df.Age))

#Calculando la desvasión estandar de la variable AGE en el DATAFRAME de los pacientes de los grupos A y B
by(data, :Treatment, df -> std(df.Age))


#Podemos usar summarystats() para obtener toda la información básica de estadística descriptiva de la variable en cuestion
by(data, :Treatment, df -> describe(df.Age))


#Visualización de los datos
#El paquete Plots trabaja muy bien con los DataFrames. 
#En el siguiente código vamos a tener la distribución de la variable age 
#respecto a los dos grupos de tratamiento

@df data density(
        :Age, 
        group = :Treatment, 
        title = "Distribution of ages by treatment group", 
        xlab = "age", 
        ylab = "Distribution" , 
        legend = :topright
);

#Podemos hacer lo mismo teniendo en cuenta la variable de resultados
@df data density(
        :Age, 
        group = :Result, 
        title = "Distribution of ages by result group",
        xlab = "age", 
        ylab = "Distribution" , 
        legend = :topright
);

#Podemos discriminar cada uno de los grupos
@df data density(
        :Age, group = (:Treatment, :Result), 
        title = "Distribution of ages by treatment and result group", 
        xlab = "age", 
        ylab = "Distribution" , 
        legend = :topright
);

#Podemos graficar un box-and-whisker plot BOX PLOT podemos observar en 
#las siguiente líneas de código, la cuenta de celúlas blancas por grupo de 
#tratamiento y grupo por resultados
@df data boxplot(
        :Treatment, 
        :WCC, 
        lab = "WCC", 
        title = "White cell count treatment group", 
        xlab= "Groups", 
        ylab="WCC"
);

@df data boxplot(
        :Result, 
        :WCC, 
        lab = "WCC", 
        title = "White cell count result group", 
        xlab= "Groups", 
        ylab="WCC"
);

#Finalmente vamos a observar la correlación entre las variables 
#numéricas usando la gráfica de correlación y corner plot

@df data corrplot(
        [:Age :WCC :CRP], 
        grid = false
); #No agregar coma entre los elementos en el vector

@df data cornerplot(
        [:Age :WCC :CRP], 
        grid = false, 
        compact = true
);
