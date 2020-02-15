import numpy as np
import os
import cv2

N = 100

def separate(matrix_in):
    r, c = np.shape(matrix_in)
    avg = matrix_in.mean(1)
    matrix = np.zeros((r, c))

    for i in range(r):
        for j in range(c):
            matrix[i, j] = matrix_in[i, j] - avg[i]
    return matrix, avg

def read_faces(path):
    face_mat = np.empty((N**2, 1))
    dir = os.listdir(path)
    for x in dir:
        img = cv2.imread(path + '/' + x, cv2.IMREAD_GRAYSCALE)
        resized_img = cv2.resize(img, (N, N))
        column_vec = resized_img.flatten('F')
        face_mat = np.column_stack((face_mat, column_vec))
    return face_mat[:,1:]

def decomp(norm_face_mat):
    r, c = np.shape(norm_face_mat)
    u, s, vh = np.linalg.svd(norm_face_mat, full_matrices=True)

    # Need to create sigma matrix.
    smat = np.zeros((r, c))
    smat[:c, :c] = np.diag(s)

    # Testing that SVD worked.
    # print np.allclose(norm_face_mat, np.dot(u, np.dot(smat, vh)))

    face_dist = np.zeros((r, c))

    for i in range(c):
        face_dist[:, i] = np.dot(u[:, 0:r], norm_face_mat[:, i])
    return u, smat, face_dist

def projector(u, face):
    return np.dot(u[:,0:N**2], face);

def main():
    face_mat = read_faces('Plain')
    norm_face_mat, avg = separate(face_mat)
    u, smat, projections = decomp(norm_face_mat)


    face_mat_2 = read_faces('Smile')

    c = np.size(face_mat_2, 1)

    for i in range(c):
        face_mat_2[:,i] = face_mat_2[:,i] - avg

    norm_face_mat_2, avg_2 = separate(face_mat_2)

    for i in range(c):
        print('Chosen Image: ' + str(i))

        y = projector(u, face_mat_2[:, i])

        E_r = np.zeros((c, 1))

        for i in range(c):
           E_r[i,] = np.linalg.norm(y - projections[:,i])

        value, index = min(E_r), np.argmin(E_r)

        error = 100*(np.mean(E_r) - value) / np.mean(E_r);
        print('Output Image: ' + str(index))
        print('Cerntainty: ' + str(error))

if __name__ == '__main__':
    main()
