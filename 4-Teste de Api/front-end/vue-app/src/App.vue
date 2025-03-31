<template>
  <div id="app">
    <h1 class="title">Busca Operadoras de Saúde</h1>
    <div class="search-container">
      <input
        v-model="query"
        @input="buscar"
        placeholder="Digite a consulta"
        class="search-input"
      />
    </div>
    <div v-if="resultados.length > 0" class="results">
      <ul>
        <li v-for="(item, index) in resultados" :key="index" class="result-item">
          <span class="operator-name">{{ item.nome_operadora }}</span>
          <span class="operator-code">{{ item.codigo_operadora }}</span>
        </li>
      </ul>
    </div>
    <div v-else>
      <p class="no-results">Nenhum resultado encontrado.</p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'App',
  data() {
    return {
      query: '',
      resultados: [],
    };
  },
  methods: {
    async buscar() {
      if (this.query.length < 3) {
        this.resultados = [];
        return;
      }
      try {
        const response = await fetch(`http://127.0.0.1:5000/buscar?query=${this.query}`);
        const data = await response.json();
        this.resultados = data;
      } catch (error) {
        console.error('Erro ao buscar:', error);
      }
    },
  },
};
</script>

<style>
#app {
  font-family: 'Arial', sans-serif;
  padding: 20px;
  background-color: #f4f7fb;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
}

.title {
  font-size: 2em;
  margin-bottom: 20px;
  color: #333;
}

.search-container {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.search-input {
  padding: 10px;
  font-size: 16px;
  width: 350px;
  border: 2px solid #ccc;
  border-radius: 5px;
  outline: none;
  transition: border-color 0.3s ease;
}

.search-input:focus {
  border-color: #5e72e4;
}

.results {
  width: 100%;
  max-width: 500px;
  margin-top: 20px;
}

.result-item {
  padding: 15px;
  border: 1px solid #ddd;
  border-radius: 8px;
  margin-bottom: 10px;
  background-color: #fff;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.operator-name {
  font-weight: bold;
  color: #333;
}

.operator-code {
  font-style: italic;
  color: #555;
}

.no-results {
  color: #ff4d4f;
  font-size: 1.2em;
  text-align: center;
}
</style>
