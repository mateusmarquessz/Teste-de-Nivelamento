import os
import pandas as pd
import zipfile
import PyPDF2
import pdfplumber


pdf_file = "../downloads/Anexo_I_Rol_2021RN_465.2021_RN627L.2024.pdf"
output_csv = "Rol_de_Procedimentos.csv"
nome_usuario = "Mateus"
output_zip = f"Teste_{nome_usuario}.zip"


abreviacoes = {"OD": "Odontológico", "AMB": "Ambulatorial"}

def extrair_tabela_do_pdf(pdf_path):
    dados = []
    with pdfplumber.open(pdf_path) as pdf:
        for page in pdf.pages:
            tables = page.extract_tables()
            for table in tables:
                for row in table:
                    dados.append(row)
    return dados

def salvar_como_csv(dados, csv_path):
    df = pd.DataFrame(dados)
    df = df.rename(columns={0: "Código", 1: "Procedimento", 2: "OD", 3: "AMB"})
    df.replace({"OD": abreviacoes, "AMB": abreviacoes}, inplace=True)
    df.to_csv(csv_path, index=False, encoding="utf-8")

def compactar_csv(csv_path, zip_path):
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zipf:
        zipf.write(csv_path, os.path.basename(csv_path))

def main():
    dados = extrair_tabela_do_pdf(pdf_file)
    if dados:
        salvar_como_csv(dados, output_csv)
        compactar_csv(output_csv, output_zip)
        print(f"Processo concluído. Arquivo salvo como {output_zip}")
    else:
        print("Nenhum dado foi extraído do PDF.")

if __name__ == "__main__":
    main()