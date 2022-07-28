import { useState } from "react";
import "react-dropzone-uploader/dist/styles.css";
import Dropzone from "react-dropzone-uploader";
import axios from "axios";

const Uploader = () => {
  const handleChangeStatus = ({ meta, remove }: any, status: any) => {
    setAllowViewFiles(false);
    setTriggerChange(Math.random());
    sets3Links([]);
    setError("");
  };

  const [, setTriggerChange] = useState<number>(Math.random());
  const [isUploading, setisUploading] = useState<boolean>(false);
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false);
  const [allowViewFiles, setAllowViewFiles] = useState<boolean>(false);
  const [s3Links, sets3Links] = useState<string[]>([]);
  const [error, setError] = useState<string>("");

  const [imageId, setImageId] = useState<string>("");
  const handleSubmit = async (files: any) => {
    setisUploading(true);
    const f = files[0];

    try {
      const response = await axios.get(
        "https://q4hoq7l5m4.execute-api.us-east-1.amazonaws.com/dev/presign-url"
      );

      await fetch(response.data.url, {
        method: "PUT",
        body: f["file"],
        headers: {
          "Content-Type": f.type,
        },
      });

      setAllowViewFiles(true);
      setImageId(response.data.id);
    } catch (error) {
      console.error(error);
      alert("File failed to upload, please check the logs.");
    } finally {
      setisUploading(false);
    }
  };

  const handleGetLinks = async (e: any) => {
    setError("");
    sets3Links([]);
    setIsSubmitting(true);

    try {
      const response = await axios.get(
        `https://q4hoq7l5m4.execute-api.us-east-1.amazonaws.com/dev/image/${imageId}`
      );

      sets3Links(response.data.links);
    } catch (error) {
      setError(
        "The links are not ready yet, please wait a moment before trying again."
      );
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div
      style={{
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
      }}
    >
      <Dropzone
        onChangeStatus={handleChangeStatus}
        onSubmit={handleSubmit}
        maxFiles={1}
        multiple={false}
        canCancel={false}
        submitButtonDisabled={isUploading}
        submitButtonContent={isUploading ? "Uploading..." : "Upload"}
        accept="image/jpeg, image/png"
        inputContent="Upload an image"
        styles={{
          dropzone: { height: 200, width: 400 },
          dropzoneActive: { borderColor: "green" },
        }}
      />

      {allowViewFiles && (
        <>
          <button
            className="dzu-submitButton"
            style={{
              width: 400,
            }}
            disabled={isSubmitting}
            onClick={(e) => handleGetLinks(e)}
          >
            {isSubmitting ? "Getting Links..." : "Get links"}
          </button>

          {error && <p>{error}</p>}

          {s3Links.length > 0 && (
            <div
              style={{
                marginTop: "10px",
              }}
            >
              <ul
                style={{
                  fontSize: "0.9rem",
                  lineHeight: "1.4rem",
                }}
              >
                {s3Links.map((link) => (
                  <li>
                    <a href={link} target="_blank" rel="noreferrer">
                      {link}
                    </a>
                  </li>
                ))}
              </ul>
            </div>
          )}
        </>
      )}
    </div>
  );
};

export default Uploader;
