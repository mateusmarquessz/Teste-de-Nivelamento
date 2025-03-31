from flask import Flask, jsonify, request
import pandas as pd

app = Flask(__name__)

df = pd.read_csv('../../3-Banco de Dados/csv/Relatorio_cadop.csv')


@app.route('/buscar', methods=['GET'])
def buscar():
    query = request.args.get('query', '')
    
    resultado = df[df.apply(lambda row: row.astype(str).str.contains(query, case=False).any(), axis=1)]

    return jsonify(resultado.to_dict(orient='records'))

if __name__ == '__main__':
    app.run(debug=True)
